class SessionsController<ApplicationController

  def new
    if current_admin?
      redirect_to "/admin"
      flash[:error] = "You are already logged in."
    elsif current_merchant?
      redirect_to "/merchant"
      flash[:error] = "You are already logged in."
    elsif current_user
      redirect_to "/profile"
      flash[:error] = "You are already logged in."
    end
  end
  
  def create
    if user = User.find_by_email(params[:email])
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:success] = "Success, you are now logged in as #{user.name}"
        if current_admin?
          redirect_to '/admin'
        elsif current_merchant?
          redirect_to "/merchant"
        else
          redirect_to "/profile"
        end
      else
        flash[:error] = "Your login credentials are incorrect"
        render :new
      end
    else
      flash[:error] = "Your login credentials are incorrect"
      render :new
    end
  end
end