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
    if !current_user
      flash.now[:notice] = "You must #{view_context.link_to 'Register', '/register'} or #{view_context.link_to 'Login', '/login'} in order to checkout".html_safe
    end
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end


end
