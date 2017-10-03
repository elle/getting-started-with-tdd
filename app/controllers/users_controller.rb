class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to user_path(@user), notice: "Horay!"
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])

    render :show
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
