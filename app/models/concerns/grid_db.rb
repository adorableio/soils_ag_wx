module GridDb
  MIN_LATITUDE = 42.0 # FIXME: Should derive this from the Grid file, really
  STEP = 0.4 # FIXME: Likewise!

  require 'agwx_grids'
  # Using http://stackoverflow.com/questions/10692961/inheriting-class-methods-from-mixins
  # Since I want to mix in both class and instance methods with one module
  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods
  end

  module ClassMethods
    include AgwxGrids

    def evapotranspirations_url
      "#{Endpoint::BASE_URL}/evapotranspirations"
    end

    def weather_url
      "#{Endpoint::BASE_URL}/weather"
    end

    def longitude_cols
      self.column_names.select { |cn| cn =~ /w[\d]{3}/ }.sort { |a, b| b <=> a } # e.g. 'w980' before 'w976'
    end

    def longitude_col(longitude)
      l_cols = longitude_cols
      westmost = -1 * (l_cols[0].sub('w','').to_f) / 10.0 # 98.0
      l_cols[Grid.nearest(longitude,westmost,STEP)]
    end

    def nearest_latitude(latitude)
      MIN_LATITUDE + STEP * Grid.nearest(latitude,MIN_LATITUDE,STEP)
    end

    def daily_series(start_date, end_date, long, lat)
      long *= -1 if long < 0
      url = "#{self.base_url}?lat=#{lat}&long=#{long}&start_date=#{start_date}&end_date=#{end_date}"
      response = HTTParty.get(url, { timeout: 5 })
      body = JSON.parse(response.body)
      body.map { |h| [h['date'], h[self.endpoint_attribute_name]] }.to_h
    end

    def date_for(year,doy)
      Date.civil(year,1,1) + doy - 1
    end

    def import_grid(grid_filename,year)
      grid = Grid.new(grid_filename,Grid::DAILY)
      long_cols = longitude_cols
      recs = self.where(date: (Date.civil(year,1,1)..Date.civil(year,12,31)))

      # Make a list of all the layers in this grid that aren't in (or are incomplete in) the database
      doys = grid.layer_list.inject([]) do |arr,doy|
        # Number of latitude rows for each date should == rows in a layer
        if recs.select { |rec| rec.date = date_for(year,doy) }.count < grid.layer(doy).rows.size
          arr << doy
        else
          arr
        end
      end
      # for each doy
      doys.each do |doy|
        layer = grid.layer(doy)
        date = date_for(year,doy)
        layer.rows.each_with_index do |row,index|
          latitude = grid.latitude_for(index)
          db_row = self.new date: date, latitude: latitude
          (0..row.size-1).each do |col_index|
            db_row[long_cols[col_index]] = row[col_index]
          end
          db_row.save!
        end
      end
    end
  end
end
