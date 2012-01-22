class Link < ActiveRecord::Base
  belongs_to :user
  belongs_to :source, :counter_cache => true

  before_create :parse

  VIDEO_HOSTS = ['www.youtube.com']

  def parse
    set_source
    clean_title
    clean_url
  end

  def uri
    @uri ||= URI.parse(self.url)
  end

  def params
    @params ||= CGI.parse(self.uri.query)
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

  def youtube_embed_code(size)
    case size
    when :default
      width, height = 420, 315
    when :small
      width, height = 315, 236
    when :large
      width, height = 630, 473
    end
    "<iframe width='#{width}' height='#{height}' src='http://www.youtube.com/embed/#{self.params['v'][0]}' frameborder='0' allowfullscreen></iframe>".html_safe
  end

  def set_source
    source = Source.find_or_create_by_url(self.uri.host)
    self.source = source
  end

  def clean_title
    case uri.host
    when 'www.youtube.com'
      self.title.gsub!(/ - YouTube/, '')
    end
  end

  def clean_url
    case uri.host
    when 'www.youtube.com'
      self.url = "#{uri.scheme}://#{uri.host}/watch?v=#{self.params['v'][0]}"
    end
  end

end
