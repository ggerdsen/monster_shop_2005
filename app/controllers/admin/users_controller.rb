class Admin::UsersController < Admin::BaseController

  before_action :require_admin
  def index
    @users = User.all
  end

end
