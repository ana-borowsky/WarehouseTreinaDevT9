class Api::V1::WarehousesController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :return_500
  rescue_from ActiveRecord::RecordNotFound, with: :return_404

  def show
    warehouse = Warehouse.find(params[:id])
    render status: 200, json: warehouse.as_json(except: [:created_at, :updated_at])
  end

  def index
    warehouses = Warehouse.all.order(:name)
    render status: 200, json: warehouses
  end

  def create
    warehouse_params = params.require(:warehouse).permit(:name, :code, :address, :area, :description, :cep, :city)
    warehouse = Warehouse.new(warehouse_params)
    # o código abaixo faz o mesmo que o strong parameters warehouse_params
    # warehouse.name = params["name"]
    # warehouse.code = params["code"]
    if warehouse.save
      render status: 201, json: warehouse
    else
      render status: 412, json: { errors: warehouse.errors.full_messages }
    end
  end

  private

  def return_500
    render status: 500
  end

  def return_404
    render status: 404
  end
end

# module Api 
#   module V1 
#     class ProductsController < ActionController::API
#   end
# end