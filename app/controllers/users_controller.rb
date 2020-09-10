class  UsersController < ApplicationController

  def new

  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "You are now registered and logged in"
      session[:user_id] = @user.id
      redirect_to "/profile"
    else
      flash[:error] = @user.errors.full_messages.uniq.to_sentence
      render :new
    end
  end

  def show
    @user = current_user
    render file: "/public/404" unless current_user
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end

end
