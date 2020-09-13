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
    order = current_user.orders.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price,
          status: "pending"
          })
      end
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

  def ship
    order = Order.find(params[:id])
    order.update(status: "shipped")
    order.save
    redirect_to "/admin"
  end


  private

  def order_params
    user_id = current_user.id
    params.permit(:name, :address, :city, :state, :zip, :user_id)
  end
end
