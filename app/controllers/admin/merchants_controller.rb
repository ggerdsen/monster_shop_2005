class Admin::MerchantsController < Admin::BaseController

  before_action :require_admin
    def index
      @merchants = Merchant.all
    end

    def show
      @merchant = Merchant.find(params[:id])
    end

    def update
      merchant = Merchant.find(params[:id])
      if merchant.disabled == false
        merchant.update(disabled: true)
        merchant.deactivate_items
        flash[:notice] = "#{merchant.name}'s account has been disabled."
        redirect_to "/admin/merchants"
      else
        merchant.update(disabled: false)
        merchant.activate_items
        flash[:notice] = "#{merchant.name}'s account is now enabled."
        redirect_to "/admin/merchants"
      end
    end
end
