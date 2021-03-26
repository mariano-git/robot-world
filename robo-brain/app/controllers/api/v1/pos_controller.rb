class Api::V1::PosController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]

  # GET /api/v1/pos
  def index
    @orders = Api::V1::Pos.all

    render json: @orders
  end

  # GET /api/v1/pos/1
  def show
    render json: @order
  end

  def getRevenueSql(modelId)
    sql = 'SELECT model.id, model.name, component.category, model_specification.qty,
      component.price_cost as unit_price_cost, (model_specification.qty * component.price_cost) as component_total_cost,
      model.revenue_factor, ((model_specification.qty * component.price_cost) * model.revenue_factor) as revenue
    FROM
    public.component, public.model_specification, public.model
    WHERE model.id = model_specification.model_id AND
    model_specification.component_id = component.id
    and model.id = :modelId order by model.id'
    queryParams = {}
    queryParams[:modelId] = modelId
    return [sql, queryParams]
  end

  # POST /api/v1/pos
  def getModelRevenue
    @revenue = Car.find_by_sql(getRevenueSql(params['modelId']))
    puts @revenue.to_json
    render json: @revenue, status: :ok
  end

  def getPurchase
    results = {}
    http_status = :created
    begin
      @car = Car.find_by model_id: params['modelId'], stage: 'QA', status: 'OK'
      if @car.blank?
        #create Requisition
        #
        Requisition.insert!(
          { requester: params['buyer'],
            model_id: params['modelId'],
            status: 'FAIL'
          })
        raise Exception.new "Not Inventory for requested model"
      end

      #create Requisition
      @requisition = Requisition.new
      @requisition.requester = params['buyer']
      @requisition.model = @car.model
      @requisition.status = 'OK'

      # create Purchase
      # For some reason I don't understand right now(a bug perhaps), the foreign key is ignored and the
      # car serial number (car_sn field on Purchase table) is not included in the generated statement giving us this
      # INSERT INTO "purchase" ("buyer", "requisition_id", "created_at", "updated_at")
      # VALUES ($1, $2, $3, $4) RETURNING "id"  [["buyer", "string"],
      # ["requisition_id", 4], ["created_at", "2021-03-24 15:02:01.246579"],
      # ["updated_at", "2021-03-24 15:02:01.246579"]]
      #
      # Need to run it manually...
      #

      #@purchase = Purchase.insert
      #@purchase.buyer = params['buyer']
      #@purchase.requisition = @requisition
      #@purchase.car = @car
      #@purchase.save
      @requisition.transaction do
        @requisition.save
        @purchase = Purchase.insert!(
          { buyer: params['buyer'],
            requisition_id: @requisition.id,
            car_sn: @car.serial_num }
        )
        # update Car Status
        @car.update_columns stage: 'SOLD', status: 'OK'
      end

      results = {
        'carId' => @car.id,
        'carSerial' => @car.serial_num,
        'modelName' => @car.model.name,
        'modelId' => @car.model.id,
        'status' => 'SOLD',
        'purchaseId' => @purchase[0]['id'],
        'requisitionId' => @requisition.id
      }
    rescue Exception => e
      puts e
      results = {
        'modelId' => params['modelId'],
        'status' => 'FAIL',
        'message' => e.message
      }
      http_status = :not_found
    end
    render json: results, status: http_status
  end

  def getRequisition
    render json: {
      'modelId' => params['modelId'],
      'status' => 'FAIL',
      'message' => 'Not implemented yet'
    }, status: :not_implemented
  end

  def create

    action = params['type']

    if(action.eql?('REVENUE'))
      getModelRevenue
    elsif (action.eql?('PURCHASE'))
      getPurchase
    elsif (action.eql?('REQUISITION'))
      getRequisition
    end


  end

  # PATCH/PUT /api/v1/pos/1
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/pos/1
  def destroy
    @order.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    #@order = Api::V1::Pos.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.fetch(:order, {})
  end
end
