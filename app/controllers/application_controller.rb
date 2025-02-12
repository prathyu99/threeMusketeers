class ApplicationController < ActionController::Base

  helper_method :current_user
  helper_method :is_admin
  helper_method :get_user_id




  def current_user
    if session[:user_id]
      @current_user ||= Attendee.find(session[:user_id])
    else
      @current_user = nil
    end
  end

  def is_admin
    if current_user and current_user.Email.include? 'admin123@gmail.com'
      true
    else
      false
    end
  end

  def get_user_id
    current_user.id
  end

  def get_user_name
    current_user.name
  end



end