class AwonController < ApplicationController
  
  def index
    @blogs = Blog.find(:all, :order => 'date desc')
    select_data
  end
  
  def awon_check_boxes
    select_data
    render :partial => 'awon_check_boxes', :layout => false
  end

  def select_data
    begin
      @report_type = params[:report_type].to_i
    rescue => e
      logger.warn 'incorrect report type passed in: ' + e.to_s
      @report_type = "411"
    end
    @report_types = [
      ["Daily Weather","411"],
      ["Daily Soil Temperatures","412"],
      ["Hourly & Half-Hourly Weather/Soil (Current)","403"] ,
      ["Pre-2000 Half-Hourly Weather/Soil","406"],
      ["Five-Minute Precip/Wind","401"]
    ]
    @db_class = report_type(@report_type)
    @ahrs = @db_class.attr_human_readables
  end

  def station_info
    connect
    @stns = Station.find_by_sql('SELECT s.*,min(d.theDate) as first,max(d.theDate) as last FROM `stations` s, `t_411` d WHERE s.id = d.stnid group by d.stnid order by status desc,name')
  end
  
  def graphs
  end
  
  def graphs_soiltemp
  end
  
  def blog
    connect
    @blogs = Blog.find(:all, :order => 'date desc')
  end
  
  def awon_seven_day
  end

  def download_data
    begin
      stnid = (params[:stnid] || 4751).to_i
      stn = AwonStation.find_by_stnid(stnid)
      stnid = stn[:id]
    rescue Exception => e
      stnid = 1
    end
    
    use_abbrevs = ("true" == params[:use_abbrevs]) # false if missing too
    select_data # sets @report_type, @report_types, @db_class, and @ahrs
    begin
      start_date = Date.parse(params[:start_date] || (Date.today - 6.days).to_s)
      end_date = Date.parse(params[:end_date] || Date.today.to_s)
    rescue
      start_date = Date.today - 6.days
      end_date = Date.today
    end

    if params[:data_field]
      @ahrs.delete_if do |pair|
        params[:data_field][pair[0]] == nil
      end
    end
        
    @results = @db_class.find(:all,:conditions => ['awon_station_id = ? and date >= ? and date <= ?',stnid,start_date,end_date])
    respond_to do |format|
      format.html do
        text = @db_class.csv_header(use_abbrevs,@ahrs) + "<br/>"
        text += @results.collect { |rec| rec.to_csv(@ahrs) }.join("<br/>")
        render :text => text
      end
      format.csv do
        text = @db_class.csv_header(use_abbrevs,@ahrs)
        text += @results.collect { |rec| rec.to_csv(@ahrs) }.join("")
        render :text => text
      end
    end
    
  end
  
  private
  def report_type(number)
    puts "number is #{number}"
    case number
    when 411
      T411
    when 412
      T412
    when 406
      T406
    when 401
      T401
    when 403
      T403
    else
      T411
    end
  end
  
  
end
