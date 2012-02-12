class SiteController < ApplicationController

  before_filter :authenticate_user!, :except => ['process_twitter_callback', 'sign_up']

  respond_to :html, :js

  def index
  end

  def authenticate
    if !current_user
      redirect_to '/auth/twitter'
    end
  end

  def process_twitter_callback
    omniauth = request.env["omniauth.auth"]

    case params[:type]
    when 'link_account'
    when 'signin'
      user = User.find_by_twitter_uid(omniauth['uid'])

      if user
        sign_in_and_redirect(:user, user)
      else
        flash[:error] = "Sorry, the Twitter user #{omniauth['info']['nickname']} isn't linked to any accounts."
        redirect_to new_user_session_path
      end
    else
      render :text => params
    end

    # user = User.find_by_uid(omniauth['uid'])

    # if user
    #   sign_in_and_redirect(:user, user)
    # else
    #   if params[:invite] == 'blahblahblah'
    #     user = User.find_by_uid(omniauth['uid'])
    #     if user
    #       flash[:notice] = "This account has already signed up."
    #       sign_in_and_redirect(:user, user)
    #     else
    #       user = User.new(
    #         :uid                => omniauth['uid'],
    #         :oauth_token        => omniauth['credentials']['token'],
    #         :oauth_token_secret => omniauth['credentials']['secret'],
    #         :nickname           => omniauth['info']['nickname'],
    #         :name               => omniauth['info']['name'],
    #         :image              => omniauth['info']['image']
    #       )
    #       user.save!
    #       sign_in_and_redirect(:user, user)
    #     end
    #   else
    #     flash[:error] = "Sorry, the account #{omniauth['info']['nickname']} isn't registered."
    #     redirect_to new_user_session_path
    #   end
    # end
  end

  def no_welcome
    current_user.update_attributes :show_welcome => false
  end

end
