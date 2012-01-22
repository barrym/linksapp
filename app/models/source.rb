class Source < ActiveRecord::Base

  has_many :links

  before_create :parse

  NAME_MAPPINGS = {
    'youtube.com'    => 'YouTube',
    'metafilter.com' => 'MetaFilter',
    'boingboing.net' => 'Boing Boing',
    'bbc.co.uk'      => 'BBC'
  }

  def display_name
    self.name || self.url
  end

  def parse
    clean_url!
    set_name!
  end

  def set_name!
    self.name = NAME_MAPPINGS[self.url]
  end

  def clean_url!
    self.url = self.class.clean_url(self.url)
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

end
