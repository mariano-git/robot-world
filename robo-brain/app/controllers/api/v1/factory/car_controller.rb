class Api::V1::Factory::CarController < ApplicationController
  attr_reader :car
  before_action :set_car, only: [:show, :update, :destroy]

  # GET /api/v1/factory/car
  def index
    @car = Api::V1::Factory::Car.all

    render json: @car
  end

  # GET /api/v1/factory/car/1
  def show
    render json: @car
  end

  # POST /api/v1/factory/car
  def create

    # These cars are always belong to FACTORY Warehouse
    #
    car_params = params
    @warehouse = Warehouse.find_by location: 'FACTORY'
    @model = Model.find(car_params[:model_id])

    @car = Car.create
    @car.serial_num = car_params[:serial_num]
    @car.model = @model
    @car.warehouse = @warehouse
    @car.stage = car_params[:stage]
    @car.status = car_params[:status]

    if @car.save
      render json: @car, status: :created
    else
      render json: @car.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/factory/car/1
  def update
    assemblies = params['assemblies']

    unless assemblies
      if @car.update(stage: params['stage'], status: params['status'])
        render json: { 'OK' => 'Good Work - Thank you!!' }, status: :ok
        return
      end
      render json: { 'error' => 'Can\'t update Car' }, status: :unprocessable_entity
      return
    end
    
    if @car.update(stage: params['stage'])

      to_insert = []
      assemblies.each do |a|

        to_insert.push({ 'name' => a['name'],
                         'car_serial_num' => params['id'],
                         'component_id' => a['component_id'],
                         'component_serial_num' => a['component_serial'] })

      end
      Assembly.insert_all (to_insert)
    else
      render json: { 'error' => 'Can\'t update Car' }, status: :unprocessable_entity
      return
    end
    render json: { 'OK' => 'Car Updated' }, status: :ok

  end

  # DELETE /api/v1/factory/car/1
  def destroy
    puts "DESTROY"
    @car.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_car
    puts "params id? #{params[:id]}"
    @car = Car.find_by(serial_num: params[:id])
  end

  # Only allow a list of trusted parameters through.
  # def car_params
  #  params.fetch(:car, {})
  #.permit(:serial, :modelId, :status, :stage)
  #params.fetch(:car, {"serial", "modelId", "status", "stage"})
  #params.permit(:serial, :modelId, :status, :stage)
  #end

end
