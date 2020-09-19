class Merchant::BulkDiscountsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user.merchant_id)
    @discounts = @merchant.bulk_discounts
  end

  def new
    @merchant = Merchant.find(current_user.merchant_id)
  end
  
  def create
    @merchant = Merchant.find(current_user.merchant_id)
    if @merchant.bulk_discounts.create(discount_params)
      flash[:success] = "Discount Saved: #{discount_params[:title]} #{discount_params[:percent_discount]}% off of a group of like items when you purchase #{discount_params[:minimum_item_quantity]}!"
      redirect_to "/merchant"
    else
      flash[:error] = @merchant.errors.full_messages.to_sentence
      render :new
    end
  end
  
  def edit
    @discount = BulkDiscount.find(params[:discount_id])
  end
  
  def update
    discount = BulkDiscount.find(params[:discount_id])
    updated = discount.updated_at
    discount.update(discount_params)
    if discount.updated_at != updated
      flash[:success] = "Discount Updated: #{discount_params[:title]} #{discount_params[:percent_discount]}% off of a group of like items when you purchase #{discount_params[:minimum_item_quantity]}!"
      redirect_to "/merchant"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end
  
  private
  
  def discount_params
    params.permit(:title, :minimum_item_quantity, :percent_discount)
  end
  
end