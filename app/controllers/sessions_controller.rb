class SessionsController < ApplicationController
  def new
  end

  def create
    user = Attendee.find_by_Email(params[:email_address])
    if user && user.Password==(params[:password])
      session[:user_id] = user.id
      redirect_to root_url
    else
      flash.now[:alert] = "Email or password is invalid"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
