class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def new

  end

  def create
    @merchant = Merchant.find(current_user.merchant_id)
    item = @merchant.items.new(item_params)
    if item.save
      redirect_to "/merchant/items"
    else
      flash[:error] = item.errors.full_messages.to_sentence
      render :new
    end
  end

  def update_activation
    item = Item.find(params[:id])
    if item.active?
      item.update(active?: false)
      flash[:notice] = "#{item.name} has been deactivated."
    else
      item.update(active?: true)
      flash[:notice] = "#{item.name} has been activated."
    end
      redirect_to "/merchant/items"
  end
  private
  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end
end
