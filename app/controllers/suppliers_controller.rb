class SuppliersController < ApplicationController
  def index
    @supplier = Supplier.all
  end

  def new
    @supplier = Supplier.new
  end

  def show
    @supplier = Supplier.find(params[:id])
  end

  def create
    supplier_params = params.require(:supplier).permit(:corporate_name, :brand_name, :registration_number, :full_address, :city, :state, :email)
    @supplier = Supplier.new(supplier_params)
    if @supplier.save()
      redirect_to root_path, notice: 'Fornecedor cadastrado com sucesso!'
    else
      flash.now[:notice] = 'Fornecedor NÃO cadastrado! Preencha todos os campos.'      
      render 'new'
    end
  end
end

