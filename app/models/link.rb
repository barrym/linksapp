require 'open-uri'
require 'yajl'

class Link < ActiveRecord::Base

  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::TextHelper

  belongs_to :user, :counter_cache => true
  belongs_to :source, :counter_cache => true

  has_many :likes, :dependent => :destroy
  has_many :likers, :through => :likes, :source => :user

  has_many :comments, :dependent => :destroy
  has_many :commenters, :through => :comments, :source => :user

  before_create :parse

  VIDEO_HOSTS = ['www.youtube.com', 'vimeo.com']

  has_attached_file :image,
    :styles => {
      :thumbnail    => "280x140^",
      :website_main => "700x700>"
    },
    :convert_options => {
      :all         => '-auto-orient',
      :thumbnail   => "-gravity center -extent 280x140"
    },
    :storage        => :s3,
    :bucket         => 'barrymitchelson_linksapp_us',
    :path           => "images/:id/:style/:filename",
    :s3_credentials => {
      :access_key_id     => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
  }

  def self.by_day
    result = {}
    Link.order('updated_at desc').includes(:source, :user).each do |link|
      time = link.updated_at.at_beginning_of_day
      result[time] ||= {:media => [], :article => []}
      if link.is_image? || link.is_video?
        result[time][:media] << link
      else
        result[time][:article] << link
      end
    end
    result
  end

  def parse
    set_source
    clean_title!
    clean_url!
    set_image_video
    create_thumbnail
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

  def has_comments?
    self.comments_count && self.comments_count > 0
  end

  def is_media?
    is_video? || is_image?
  end

  def set_image_video
    self.is_video = VIDEO_HOSTS.include?(uri.host)
    self.is_image = !!(self.url =~ /\.(jpg|jpeg|gif|png)$/i)
  end

  def is_youtube?
    uri.host == 'www.youtube.com'
  end

  def is_vimeo?
    uri.host == 'vimeo.com'
  end

  def embed_code(size = :default)
    return youtube_embed_code(size) if is_youtube?
    return vimeo_embed_code(size) if is_vimeo?
  end

  # TODO: this should probably be in source as well
  def youtube_embed_code(size)
    case size
    when :default
      width, height = 420, 315
    when :small
      width, height = 280, 236
    when :large
      width, height = 900, 520
    end
    "<iframe width='#{width}' height='#{height}' src='http://www.youtube.com/embed/#{self.params['v'][0]}?autohide=1&hd=1&border=1&showinfo=0' frameborder='0' allowfullscreen></iframe>".html_safe
  end

  def vimeo_embed_code(size)
    case size
    when :large
      width, height = 900, 520
    end
    "<iframe src=\"http://player.vimeo.com/video/#{self.vimeo_id}?title=0&byline=0&portrait=0\" width=\"#{width}\" height=\"#{height}\" frameborder=\"0\"></iframe>".html_safe
  end

  def set_source
    self.source = Source.find_or_create_by_url(self.uri.host)
  end

  def create_thumbnail
    if is_image?
      set_image(self.url)
    elsif is_youtube?
      data = Yajl::Parser.parse(open(URI.parse("http://gdata.youtube.com/feeds/api/videos/#{self.params['v'][0]}?v=2&alt=jsonc")))
      set_image(data['data']['thumbnail']['hqDefault'])
    elsif is_vimeo?
      data = Yajl::Parser.parse(open(URI.parse("http://vimeo.com/api/v2/video/#{self.vimeo_id}.json")))
      set_image(data[0]['thumbnail_large'])
    end
  end

  def vimeo_id
    self.url =~ /vimeo\.com\/(\d*)/
    $1
  end

  def set_image(image_url)
      io = open(URI.parse(image_url))
      def io.original_filename; base_uri.path.split('/').last; end
      self.image = io.original_filename.blank? ? nil : io
  end

  def clean_title!
    self.title = self.source.clean_link_title(self.title)
  end

  # TODO: this should be in source
  def clean_url!
    remove_urchin
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
    twitter_url = "https://twitter.com/share?url=#{CGI.escape(self.url)}&text=#{CGI.escape(self.title)}&size=large"
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
