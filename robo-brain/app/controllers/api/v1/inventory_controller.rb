class Api::V1::InventoryController < ApplicationController
  #before_action :set_inventory, only: [:show, :update, :destroy]

  # GET /api/v1/inventory
  def index
    puts __method__.to_s
    @inventory = Api::V1::Inventory.all

    render json: @inventory
  end

  # GET /api/v1/inventory/1
  def show
    puts __method__.to_s
    puts params
    warehouse = params['id']
    status = params['status']
    stage = params['stage']

    @inventory = Car.find_by_sql(getCarByStatusAndWarehouseQuery(warehouse, stage, status))
    if @inventory.blank?
      render json: { 'message' => "not found" }, status: :not_found
      return
    end
    render json: @inventory
  end

  # POST /api/v1/inventory
  def create
    puts __method__.to_s
    @inventory = Api::V1::Inventory.new(inventory_params)

    if @inventory.save
      render json: @inventory, status: :created, location: @inventory
    else
      render json: @inventory.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/inventory/1
  def update
    puts __method__.to_s
    if @inventory.update(inventory_params)
      render json: @inventory
    else
      render json: @inventory.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/inventory/1
  def destroy
    puts __method__.to_s
    @inventory.destroy
  end

  private

  def getCarByStatusAndWarehouseQuery(warehouse, stage, status)
    queryParams = {}
    sqlByLocation =
      'SELECT car.id , car.serial_num as serial, model.id as modelId, model.name as modelName, warehouse.name wareHouseName,
warehouse.location as wareHouseLocation, car.status, car.stage FROM public.car, public.warehouse, public.model
WHERE car.model_id = model.id AND car.warehouse_id = warehouse.id AND warehouse.location = :wh'
    queryParams[:wh] = warehouse
    #Post.find_by_sql ["SELECT body FROM comments WHERE author = :user_id OR approved_by = :user_id", { :user_id => user_id }]

    if !stage.blank?
      sqlAndStage = ' AND car.stage = :stg'
      sqlByLocation.concat(sqlAndStage)
      queryParams[:stg] = stage
    end

    if !status.blank?
      sqlAndStatus = ' AND car.status = :stat'
      sqlByLocation.concat(sqlAndStatus)
      queryParams[:stat] = status
    end

    return [sqlByLocation, queryParams]

  end

  # Use callbacks to share common setup or constraints between actions.
  def set_inventory
    puts __method__.to_s
    @inventory = Api::V1::Inventory.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def inventory_params
    puts __method__.to_s
    params.fetch(:inventory, {})
  end
end
