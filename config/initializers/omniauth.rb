Rails.application.config.middleware.use OmniAuth::Builder do
    @twitter = YAML.load(File.read(Rails.root.join("config/omniauth.yaml")))['twitter']
    provider :twitter, @twitter['key'], @twitter['secret']
end
