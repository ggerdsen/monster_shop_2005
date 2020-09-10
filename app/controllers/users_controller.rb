class  UsersController < ApplicationController

  def new

  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "You are now registered and logged in as #{@user.name}"
      session[:user_id] = @user.id
      redirect_to "/profile"
    else
      flash[:error] = @user.errors.full_messages.uniq.to_sentence
      render :new
    end
  end

  def show
    render file: "/public/404" unless current_user
    if current_user
      @user = User.find(session[:user_id])
    end
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end

end
