class SiteController < ApplicationController

  before_filter :authenticate, :except => ['process_twitter_callback']

  def index
  end


  def authenticate
    if !current_user
      redirect_to '/auth/twitter'
    end
  end

  def process_twitter_callback
    omniauth = request.env["omniauth.auth"]
    user = User.find_by_uid(omniauth['uid'])

    if user
      sign_in_and_redirect(:user, user)
    # elsif current_user
    #   # not sure it'll be used if we only use twitter
    #   current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
    #   redirect_to root_url
    else
      user = User.new(
        :uid                => omniauth['uid'],
        :oauth_token        => omniauth['credentials']['token'],
        :oauth_token_secret => omniauth['credentials']['secret'],
        :nickname           => omniauth['info']['nickname'],
        :name               => omniauth['info']['name'],
        :image              => omniauth['info']['image']
      )
      logger.info user.inspect
      user.save!
      sign_in_and_redirect(:user, user)
    end
  end

end
