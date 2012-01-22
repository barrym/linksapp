class Link < ActiveRecord::Base
  belongs_to :user
  belongs_to :source, :counter_cache => true

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
    case uri.host
    when 'www.youtube.com'
      self.title = self.title.gsub(/ - YouTube/, '')
    when 'boingboing.net'
      self.title = self.title.gsub(/ - Boing Boing/, '')
    when 'www.metafilter.com'
      self.title = self.title.gsub(/ \| MetaFilter/, '')
    when 'www.bbc.co.uk'
      self.title = self.title.gsub(/^BBC.*?-\s/, '')
    end
  end

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

end
