class Like < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  belongs_to :link, :counter_cache => true, :touch => true

  validates_uniqueness_of :user_id, :scope => [:link_id]
end
