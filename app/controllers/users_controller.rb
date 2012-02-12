class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def create
    @user = User.new(
      :email       => params[:email],
      :nickname    => params[:nickname],
      :password    => params[:password],
      :invite_code => params[:invite_code]
    )

    if !params[:avatar_url].blank?
      @user.set_avatar_from_url(params[:avatar_url])
    elsif params[:avatar]
      @user.avatar = params[:avatar]
    end

    if @user.valid?
      @user.save!
      sign_in_and_redirect(:user, @user)
    else
      render :new
    end
  end

  def update
    @user = current_user
    attr = {
      :email => params[:email],
      :nickname => params[:nickname]
    }

    if !params[:password].blank?
      attr.merge!(:password => params[:password])
    end


    if !params[:avatar_url].blank?
      @user.set_avatar_from_url(params[:avatar_url])
    elsif params[:avatar]
      attr.merge!(:avatar => params[:avatar])
    end

    @user.attributes = attr
    if @user.valid?
      @user.save
      sign_in(@user, :bypass => true)
      flash[:success] = "Profile updated"
      redirect_to root_path
    else
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
  end

end
