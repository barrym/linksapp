class Link < ActiveRecord::Base

  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::TextHelper

  belongs_to :user, :counter_cache => true
  belongs_to :source, :counter_cache => true

  has_many :likes, :dependent => :destroy
  has_many :likers, :through => :likes, :source => :user

  before_create :parse

  VIDEO_HOSTS = ['www.youtube.com']

  def parse
    set_source
    clean_title!
    clean_url!
  end

  def uri
    @uri ||= URI.parse(self.url)
  end

  def params
    @params if @params
    if self.uri.query
      @params = CGI.parse(self.uri.query)
    else
      @params = []
    end
  end

  def is_liked?
    self.likes_count && self.likes_count > 0
  end

  def is_video?
    VIDEO_HOSTS.include?(uri.host)
  end

  def embed_code(size = :default)
    case uri.host
    when 'www.youtube.com'
      youtube_embed_code(size)
    end
  end

  # TODO: this should probably be in source as well
  def youtube_embed_code(size)
    case size
    when :default
      width, height = 420, 315
    when :small
      width, height = 280, 236
    when :large
      width, height = 630, 473
    end
    "<iframe width='#{width}' height='#{height}' src='http://www.youtube.com/embed/#{self.params['v'][0]}' frameborder='0' allowfullscreen></iframe>".html_safe
  end

  def set_source
    self.source = Source.find_or_create_by_url(self.uri.host)
  end

  def clean_title!
    self.title = self.source.clean_link_title(self.title)
  end

  # TODO: this should be in source
  def clean_url!
    remove_urchin
    puts uri.host
    case uri.host
    when 'www.youtube.com'
      self.url = "#{uri.scheme}://#{uri.host}/watch?v=#{self.params['v'][0]}"
    when 'boingboing.net'
      self.url = "#{uri.scheme}://#{uri.host}#{uri.path}"
    end
  end

  def remove_urchin
    cleaned_params = self.params.select {|p| p !~ /^utm_/}
    self.url = "#{uri.scheme}://#{uri.host}#{uri.path}"
    if !cleaned_params.empty?
      puts cleaned_params.inspect
      qs = cleaned_params.map {|k,v| v.map{|val| "#{k}=#{CGI.escape(val)}"}}.flatten.join("&")
      self.url = self.url + "?#{qs}"
    end
    self.url = self.url + uri.fragment.to_s
  end

  def self.reparse_all!
    self.all.each {|l| l.parse;l.save!}
  end

  def liked_by?(user)
    self.likers.include? user
  end

  def twitter_share_url_for(sharing_user)
    twitter_url = "https://twitter.com/share?url=#{CGI.escape(self.url)}&text=#{self.title}&size=large"
    if sharing_user != self.user
      twitter_url += "&via=#{self.user.nickname}"
    end
    twitter_url
  end

  def as_json(options = {})
    extras = {
      :source             => self.source.as_json,
      :user               => self.user.as_json,
      :shared_at_in_words => distance_of_time_in_words_to_now(self.created_at),
      :is_video           => self.is_video?,
      :is_liked           => self.is_liked?
    }
    if self.is_video?
      extras.merge!({
        :embed_code => {
          :small => self.embed_code(:small),
          :large => self.embed_code(:large)
        }
      })
    end

    if self.is_liked?
      extras.merge!({
        :likes_count => pluralize(self.likes_count, 'person')
      })
    end
    super.merge(extras)
  end

end
