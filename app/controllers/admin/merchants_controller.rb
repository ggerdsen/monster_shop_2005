class Admin::MerchantsController < Admin::BaseController

  before_action :require_admin
    def show
      @merchant = Merchant.find(params[:id])
    end

end
