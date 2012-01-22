class Source < ActiveRecord::Base

  has_many :links

  def display_name
    self.name || self.url
  end

end
