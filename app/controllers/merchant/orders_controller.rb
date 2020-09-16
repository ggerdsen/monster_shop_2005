class Merchant::OrdersController < Merchant::BaseController



  def show
    @order = Order.find(params[:id])
  end

  def update
    binding.pry
    @order = Order.find(params[:order_id])
    @order.item_orders.each do |item|
      @order.item_orders.where(item_id: params[:item_id], order_id: params[:order_id])
      @order.item_orders.select(item_id: params[:item_id])
  end
end
