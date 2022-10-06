class OrderItemsController < ApplicationController
  def new
    @order = Order.find(params[:order_id])
    @order_item = OrderItem.new()
    @products = @order.supplier.product_models
  end

  def create
    @order = Order.find(params[:order_id])
    order_item_params = params.require(:order_item).permit(:product_model_id, :quantity)
    @order.order_items.create!(order_item_params)
    # o comando acima faz o mesmo que as tres proximas linhas
    # @order_item = OrderItem.new(order_item_params)
    # @order_item.order = @order
    # @order_item.save

    redirect_to @order, notice: 'Item adicionado com sucesso.'
  end
end