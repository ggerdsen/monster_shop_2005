class SessionsController<ApplicationController

  def new
    if current_admin?
      logged_in
      redirector
    elsif current_merchant?
      logged_in
      redirector
    elsif current_user
      logged_in
      redirector
    else
    end
  end
  
  def create
    if user = User.find_by_email(params[:email])
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:success] = "Success, you are now logged in as #{user.name}"
        redirector
      else
        flash[:error] = "Your login credentials are incorrect"
        render :new
      end
    else
      flash[:error] = "Your login credentials are incorrect"
      render :new
    end
  end
  
  def destroy
    session.delete(:user_id)
    session.delete(:cart)
    flash[:notice] = "You have been logged out"
    redirect_to "/"
  end
  
  private
  
  def logged_in
    flash[:error] = "You are already logged in."
  end
  
  def redirector
    if current_admin?
      redirect_to '/admin'
    elsif current_merchant?
      redirect_to "/merchant"
    else
      redirect_to "/profile"
    end
  end
end