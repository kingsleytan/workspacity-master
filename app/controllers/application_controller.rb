class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :current_order

  rescue_from Pundit::NotAuthorizedError do |exception|
    flash[:danger] = "You're not authorized"
    redirect_to request.referrer || root_path
  end

  private

  def authenticate!
    unless current_user
      redirect_to root_path
      flash[:danger] = "You need to login first"
    end
  end

  def current_user
    return unless session[:id]
    @current_user ||= User.find_by(id: session[:id])
  end
  helper_method :current_user

  def current_order
    if !session[:order_id].nil?
      Order.find(session[:order_id])
    else
      Order.new
    end
  end
  helper_method :current_order


end
