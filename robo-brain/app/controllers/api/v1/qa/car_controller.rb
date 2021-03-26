class Api::V1::Qa::CarController < ApplicationController
  before_action :set_car, only: [:show, :update, :destroy]

  # GET /api/v1/qa/car
  def index
    puts __method__.to_s
    @car = Api::V1::Qa::Car.all

    render json: @car
  end

  # GET /api/v1/qa/car/1
  def show
    puts __method__.to_s
    computer = @car.getComputer()
    diagnostic = computer.getDiagnostics()
    @warehouse = Warehouse.find_by location: 'STORE'

    if diagnostic['diagnostic'].eql? 'FAIL'
      @car.update_columns stage: 'QA', status: 'FAIL'
      id = diagnostic['failedComponent']['assemblyId']
      @ably = Assembly.find id
      @ably.update_attribute(:failed, true)
      #ably.save

    elsif diagnostic['diagnostic'].eql? 'OK'
      @car.update_columns stage: 'QA', status: 'OK', warehouse_id: @warehouse.id

    end

    payload = {
      'id' => @car.id,
      'serial' => @car.serial_num,
      'modelName' => @car.model.name,
      'status' => diagnostic
    }

    render json: payload
  end

  # POST /api/v1/qa/car
  def create
    puts __method__.to_s
    @car = Api::V1::Qa::Car.new(car_params)

    if @car.save
      render json: @car, status: :created, location: @car
    else
      render json: @car.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/qa/car/1
  def update
    puts __method__.to_s
    if @car.update(car_params)
      render json: @car
    else
      render json: @car.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/qa/car/1
  def destroy
    puts __method__.to_s
    @car.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_car
    puts __method__.to_s
    @car = Car.includes(:assembly).find_by(serial_num: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def car_params
    puts __method__.to_s
    params.fetch(:car, {})
  end
end
