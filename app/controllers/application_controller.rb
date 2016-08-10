class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
    helper_method :current_user

  private

  def authenticate!
    unless current_user
      redirect_to root_path
      flash[:danger] = "You need to login first"
    end
  end

  def current_user
    return unless session[:id]
    @user ||= User.find_by(id: session[:id])
  end


end
