class User < ActiveRecord::Base

  has_many :links
  has_many :likes, :dependent => :destroy
  has_many :liked_links, :through => :likes, :source => :link
  has_many :comments, :dependent => :destroy
  has_many :commented_links, :through => :comments, :source => :comment # TODO: these aren't unique when returned

  validates_presence_of :email, :nickname
  validates_uniqueness_of :email
  validate :invite_code_is_valid
  validate :password_validation

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable #, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :twitter_uid,
                  :twitter_oauth_token, :twitter_oauth_secret, :twitter_nickname, :nickname, :name,
                  :show_welcome, :invite_code, :avatar

  has_attached_file :avatar,
    :styles => {
      :small    => "16x16>",
      :medium   => "24x24>",
      :large    => "48x48>",
    },
    :convert_options => {
      :all         => '-auto-orient'
    },
    :storage        => :s3,
    :bucket         => 'barrymitchelson_linksapp_us',
    :path           => "images/:id/:style/:filename",
    :s3_credentials => {
      :access_key_id     => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
  }

  def invite_code_is_valid
    if self.invite_code != 'blahblahblah'
      errors.add(:invite_code, 'is invalid')
    end
  end

  def password_validation
    if new_record?
      errors.add(:password, "can't be blank") if self.password.blank?
    end
  end

  def set_avatar_from_url image_url
    io = open(URI.parse(image_url))
    def io.original_filename; base_uri.path.split('/').last; end
    self.avatar = io.original_filename.blank? ? nil : io
  end

end
