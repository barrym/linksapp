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
        attr = {
          :twitter_uid          => omniauth['uid'],
          :twitter_oauth_token  => omniauth['credentials']['token'],
          :twitter_oauth_secret => omniauth['credentials']['secret'],
          :twitter_nickname     => omniauth['info']['nickname'],
        }
        current_user.attributes = attr
        if !current_user.avatar?
          current_user.set_avatar_from_url omniauth['info']['image']
        end
        current_user.save!
        redirect_to edit_user_path(current_user)
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

  end

  def no_welcome
    current_user.update_attributes :show_welcome => false
  end

end
