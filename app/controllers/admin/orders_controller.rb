class Admin::OrdersController < Admin::BaseController

  before_action :require_admin
  def index
    @user = User.find(params[:id])
  end

  def show
    @order = Order.find(params[:order_id])
  end
end
