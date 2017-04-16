class PasswordResetsController < ApplicationController

   def new
   end

   def create
     user = User.find_by(email: reset_password_params[:email])

     if user
       user.update(password_reset_token: password_token, password_reset_at: DateTime.now)
       PasswordResetsMailer.password_reset_mail(user).deliver_now
       flash[:success] = "We've sent you instructions on how to reset your password"
     else
       flash[:danger] = "User does not exist"
     end

     redirect_to new_password_reset_path
   end

   def edit
     @token = params[:id]
   end

   def update
     @user = User.find_by(password_reset_token: params[:id])

     if @user && token_active?
       @user.update(password: user_params[:password], password_reset_token: nil, password_reset_at: nil)
       flash[:success] = "Password updated, you may log in now"
       redirect_to root_path
     else
       flash[:danger] = "Error, token is invalid or has expired"
       render :edit
     end
   end

   private

   def reset_password_params
     params.require(:reset).permit(:email)
   end

   def user_params
     params.require(:user).permit(:password)
   end

   def password_token
     SecureRandom.urlsafe_base64
   end

   def token_active?
     (Time.now - @user.password_reset_at) < 24.hours
   end
 end
