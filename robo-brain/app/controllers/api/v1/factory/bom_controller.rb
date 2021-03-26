class Api::V1::Factory::BomController < ApplicationController
  before_action :set_bom, only: %i[show update destroy]

  # GET /api/v1/factory/bom
  def index

    remove = rand(1..11)
    @models = Model.includes({ model_specifications: :component }).where.not(id: remove)


    @payload = BomPayload.new 'mts', @models
    render json: @payload.as_payload

  end

  # GET /api/v1/factory/boms/1
  def show
    render json: @bom
  end

  # POST /api/v1/factory/boms
  def create
    @bom = Bom.new(bom_params)
    if @bom.save
      render json: @bom, status: :created, location: @bom
    else
      render json: @bom.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/factory/boms/1
  def update
    if @bom.update(bom_params)
      render json: @bom
    else
      render json: @bom.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/factory/boms/1
  def destroy
    @bom.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bom
    @bom = Api::V1::Factory::Bom.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def bom_params
    params.fetch(:bom, {})
  end
end
