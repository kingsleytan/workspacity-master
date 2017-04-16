class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def edit
    @user ||= User.friendly.find(params[:id])
    authorize @user
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "You've created a new user."
      redirect_to root_path
    else
      redirect_to new_user_path
    end
  end


  def update
    @user = User.friendly.find(params[:id])
    authorize @user
    if @user.update(user_params)
      redirect_to root_path
      flash[:success] = "You've updated your details"
    else
      redirect_to edit_user_path(@user)
      flash[:danger] = user.errors.full_messages
    end
  end



  private

  def user_params
    params.require(:user).permit(:email, :password, :image, :username, :password_confirmation, :address)
  end

end
