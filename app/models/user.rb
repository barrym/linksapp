class User < ActiveRecord::Base

  has_many :links
  has_many :likes, :dependent => :destroy
  has_many :liked_links, :through => :likes, :source => :link
  has_many :comments, :dependent => :destroy
  has_many :commented_links, :through => :comments, :source => :comment # TODO: these aren't unique when returned

  validates_presence_of :email, :nickname, :password
  validates_uniqueness_of :email
  validate :invite_code_is_valid

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable #, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :twitter_uid, :twitter_oauth_token, :twitter_oauth_secret, :nickname, :name, :image, :show_welcome, :invite_code

  def invite_code_is_valid
    if self.invite_code != 'blahblahblah'
      errors.add(:invite_code, 'is invalid')
    end
  end

end
