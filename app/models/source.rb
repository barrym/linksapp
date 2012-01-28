require 'open-uri'

class Source < ActiveRecord::Base

  has_many :links

  before_create :parse

  MAPPINGS = {
    'youtube.com'    => 'YouTube',
    'metafilter.com' => 'MetaFilter',
    'boingboing.net' => 'Boing Boing',
    'bbc.co.uk'      => 'BBC',
    'theverge.com'   => 'The Verge',
    'vimeo.com'      => 'Vimeo',
    'guardian.co.uk' => 'The Guardian'
  }

  TITLE_CLEANUPS = {
    'bbc.co.uk'      => {:regex => /^BBC.*?-\s/, :replacement => ''},
    'boingboing.net' => {:regex => / - Boing Boing$/, :replacement => ''},
    'metafilter.com' => {:regex => / \| MetaFilter$/, :replacement => ''},
    'theverge.com'   => {:regex => / \| The Verge$/, :replacement => ''},
    'youtube.com'    => {:regex => / - YouTube$/, :replacement => ''},
    'vimeo.com'      => {:regex => / on Vimeo$/, :replacement => ''},
    'guardian.co.uk' => {:regex => /\|.+?\| The (Guardian|Observer)$/, :replacement => ''}
  }

  def display_name
    self.name || self.url
  end

  def parse
    clean_url!
    set_name!
    set_favicon!
  end

  def clean_link_title(title)
    if cleanup = TITLE_CLEANUPS[self.url]
      title.gsub(cleanup[:regex], cleanup[:replacement])
    else
      title
    end
  end

  def set_name!
    self.name = MAPPINGS[self.url]
  end

  def clean_url!
    self.url = self.class.clean_url(self.url)
  end

  def set_favicon!
    icon_url = "http://#{self.url}/favicon.ico"
    has_icon = open(URI.parse(icon_url)) rescue nil
    if has_icon
      self.icon = icon_url
    end
  end

  def self.reparse_all!
    self.all.each {|s| s.parse;s.save!}
  end

  def self.find_or_create_by_url(raw_url)
    super self.clean_url(raw_url)
  end

  def self.clean_url(url)
    url.gsub(/^www\./, '')
  end

  def as_json(options = {})
    super.merge({
      :display_name => self.display_name
    })
  end

end
