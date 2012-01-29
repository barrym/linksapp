class User < ActiveRecord::Base

  has_many :links
  has_many :likes, :dependent => :destroy
  has_many :liked_links, :through => :likes, :source => :link
  has_many :comments, :dependent => :destroy
  has_many :commented_links, :through => :comments, :source => :comment # TODO: these aren't unique when returned

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable #, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :uid, :oauth_token, :oauth_token_secret, :nickname, :name, :image

end
