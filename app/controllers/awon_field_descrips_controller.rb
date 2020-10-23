class AwonFieldDescripsController < ApplicationController
  before_action :set_awon_field_descrip, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate, only: [:create, :update, :delete]


  def index
    @awon_field_descrips = AwonFieldDescrip.all
  end


  def new
    @awon_field_descrip = AwonFieldDescrip.new
  end

  def create
    @awon_field_descrip = AwonFieldDescrip.new(awon_field_descrip_params)

    respond_to do |format|
      if @awon_field_descrip.save
        format.html { redirect_to @awon_field_descrip, notice: 'Awon field descrip was successfully created.' }
        format.json { render action: 'show', status: :created, location: @awon_field_descrip }
      else
        format.html { render action: 'new' }
        format.json { render json: @awon_field_descrip.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @awon_field_descrip.update(awon_field_descrip_params)
        format.html { redirect_to @awon_field_descrip, notice: 'Awon field descrip was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @awon_field_descrip.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @awon_field_descrip.destroy
    respond_to do |format|
      format.html { redirect_to awon_field_descrips_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_awon_field_descrip
      @awon_field_descrip = AwonFieldDescrip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def awon_field_descrip_params
      params.require(:awon_field_descrip).permit(:rec_id, :column_num, :field_name, :field_abbrev, :units, :decimals)
    end
end
