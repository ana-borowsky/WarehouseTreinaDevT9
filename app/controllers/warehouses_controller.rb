class WarehousesController < ApplicationController
  before_action :set_warehouse, only:[:show, :edit, :update, :destroy]

  def index
    @warehouses = Warehouse.all
  end
  
  def show
    #set_warehouse
    @stocks = @warehouse.stock_products.group(:product_model).count
  end

  def new
    @warehouse = Warehouse.new
  end

  def create
    # warehouse_params = params.require(:warehouse).permit(:name, :code, :city, :address, :cep, :area, :description)

    @warehouse = Warehouse.new(warehouse_params)
    if @warehouse.save()
      redirect_to root_path, notice: 'Galpão cadastrado com sucesso!'
    else
      flash.now[:notice] = 'Galpão NÃO cadastrado! Preencha todos os campos.'      
      render 'new'
    end
  end

  def edit
    #set_warehouse
  end

  def update
    #set_warehouse
    if @warehouse.update(warehouse_params)
      redirect_to warehouse_path(@warehouse.id), notice: 'Galpão editado com sucesso!'
    else
      flash.now[:notice] = 'Não foi possível atualizar o galpão.'
      render 'edit'
    end
  end

  def destroy
    @warehouse.destroy
    redirect_to root_path, notice: 'Galpão removido com sucesso!'
  end


  private

  def set_warehouse
    @warehouse = Warehouse.find(params[:id])
  end

  def warehouse_params
    params.require(:warehouse).permit(:name, :code, :city, :address, :cep, :area, :description)
  end
end

# def show; end