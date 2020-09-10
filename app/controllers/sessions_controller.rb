class SessionsController<ApplicationController

  def new
    
  end
  
  def create
    if user = User.find_by_email(params[:email])
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:success] = "Success, you are now logged in as #{user.name}"
        if current_admin?
          redirect_to '/admin'
        elsif current_employee?
          redirect_to "/merchant"
        else
          redirect_to "/profile"
        end
      else
        flash[:error] = "Your password is incorrect, try again."
        render :new
      end
    else
      flash[:error] = "This is not an email we have a record of, please register."
      redirect_to "/register"
    end
  end
end