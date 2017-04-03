class ParkingSpacesController < ApplicationController
  # before_action :set_parking_space, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]


  def search
  end

  def search_api
    # binding.pry
    spaces = ParkingSpace.within(900, :origin =>[params[:lat], params[:long]])
    render json: {status: 200, data: spaces }
  end

  # GET /parking_spaces/new
  def new
    @parking_space = ParkingSpace.new
  end

  # GET /parking_spaces/1/edit
  def edit
  end

  # POST /parking_spaces
  # POST /parking_spaces.json
  def create
    space = ParkingSpace.new(user_id: current_user.id,cost: params[:cost], latitude: params[:latitude], longitude: params[:longitude], status: true, address: params[:address])
    space.save
    redirect_to "/"
  end

  # PATCH/PUT /parking_spaces/1
  # PATCH/PUT /parking_spaces/1.json
  def update
    respond_to do |format|
      if @parking_space.update()
        format.html { redirect_to @parking_space, notice: 'Parking space was successfully updated.' }
        format.json { render :show, status: :ok, location: @parking_space }
      else
        format.html { render :edit }
        format.json { render json: @parking_space.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parking_spaces/1
  # DELETE /parking_spaces/1.json
  def destroy
    @parking_space.destroy
    respond_to do |format|
      format.html { redirect_to parking_spaces_url, notice: 'Parking space was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_parking_space
    #   @parking_space = ParkingSpace.find(params[:id])
    # end
    # Never trust parameters from the scary internet, only allow the white list through.
    # def parking_space_params
    #   params.fetch(:parking_space, {})
    # end
end
