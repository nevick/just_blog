class User < ApplicationRecord
  TEMP_EMAIL_PREFIX = 'change@me'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
  :omniauth_providers => [:facebook, :vkontakte]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.avatar = auth.info.image
      user.email = auth.info.email ? auth.info.email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
      user.password = Devise.friendly_token[0,20]
    end
  end

  # mount avatar uploader
  mount_uploader :avatar, AvatarUploader
end
