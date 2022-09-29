class ProductModelsController < ApplicationController
  def index
    @product_models = ProductModel.all
  end

  def new
    @product_model = ProductModel.new
    @suppliers = Supplier.all
  end

  def create
    @suppliers = Supplier.all
    product_model_params = params.require(:product_model).permit(:name, :height, :width, :weight, :sku, :supplier_id)
    @product_model = ProductModel.new(product_model_params)
    if @product_model.save
      redirect_to @product_model #rails monta a URL do SHOW sozinho
    else
      flash.now[:notice] = 'Não foi possível cadastrar o modelo de produto.'
      render 'new'
    end
  end

  def show
    @product_model = ProductModel.find(params[:id])#, notice: 'Modelo de produto cadastrado com sucesso.'
  end
end
