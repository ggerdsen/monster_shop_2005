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
      merchant.update(disabled: true)
      flash[:notice] = "#{merchant.name}'s account has been disabled."
      redirect_to "/admin/merchants"
    end
end
