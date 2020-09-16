class Merchant::OrdersController < Merchant::BaseController



  def show
    @order = Order.find(params[:id])
  end

  def update
    binding.pry
    @order = Order.find(params[:id])
    @order.item_orders.each do |item|
      item.
  end
end
