class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    logger.info session
    @user = User.new(
      :email       => params[:email],
      :nickname    => params[:nickname],
      :password    => params[:password],
      :invite_code => params[:invite_code]
    )
    if @user.valid?
      @user.save!
      sign_in_and_redirect(:user, @user)
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

end
