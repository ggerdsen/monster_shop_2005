class CartController < ApplicationController
  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def show
    render file: "/public/404" if current_admin?
    @items = cart.items
    if !@items.empty? && !discount_loop(@items).nil?
      @best_discount = BulkDiscount.find(discount_loop(@items).to_s)
    end
    if !current_user
      flash.now[:notice] = "You must #{view_context.link_to 'Register', '/register'} or #{view_context.link_to 'Login', '/login'} in order to checkout".html_safe
    end
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def destroy
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def update
    if params[:modify] == "add"
      cart.add_quantity(params[:item_id]) unless cart.out_of_stock?(params[:item_id])
    elsif params[:modify] == "subtract" && cart.item_count(params[:item_id]) >= 1
      cart.subtract_quantity(params[:item_id])
      return destroy if cart.item_count(params[:item_id]) == 0
    end
    redirect_to '/cart'
  end
  
  private
  
  def discount_loop(items)
    @best_discount = []
    items.map do |item|
      item = Item.find(item.first.id)
      merchant = Merchant.find(item.merchant_id)
      @best_discount << BulkDiscount.get_best(merchant.id, item, cart.contents[item.id.to_s])
    end.flatten.compact.first
  end
end
