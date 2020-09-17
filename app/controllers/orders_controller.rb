class OrdersController <ApplicationController

  def new
  end

  def index
    @user = User.find(current_user.id)
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = current_user.orders.new(order_params)
    if order.save
      cart.modify(order)
      session.delete(:cart)
      if current_user.role == "default"
        flash[:success] = "Your order has been created"
        redirect_to "/profile/orders"
      else
        redirect_to "/orders/#{order.id}"
      end
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def update
    order = Order.find(params[:order_id])
    order.update(status: "cancelled")
    order.edit_item_orders
    order.restock_items
    flash[:success] = "Your order has been cancelled"
    redirect_to "/profile"
  end

  def ship
    order = Order.find(params[:id])
    order.update(status: "shipped")
    redirect_to "/admin"
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip, :user_id)
  end
end
