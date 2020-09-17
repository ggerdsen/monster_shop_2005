class Admin::UsersController < Admin::BaseController

  before_action :require_admin
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
end
