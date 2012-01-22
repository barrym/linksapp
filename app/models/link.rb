class Link < ActiveRecord::Base
  belongs_to :user
  belongs_to :source, :counter_cache => true

  before_create :parse

  def parse
    set_source
    clean_title
    clean_url
  end

  def uri
    @uri ||= URI.parse(self.url)
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
      params = CGI.parse(uri.query)
      self.url = "#{uri.scheme}://#{uri.host}/watch?v=#{params['v'][0]}"
    end
  end

end
