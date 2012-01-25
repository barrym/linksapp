Rails.application.config.middleware.use OmniAuth::Builder do
    if ENV['TWITTER_KEY'] && ENV['TWITTER_SECRET']
      @twitter = {
        'key'    => ENV['TWITTER_KEY'],
        'secret' => ENV['TWITTER_SECRET']
      }
    else
      @twitter = YAML.load(File.read(Rails.root.join("config/omniauth.yaml")))['twitter']
    end
    provider :twitter, @twitter['key'], @twitter['secret']
end
