class User < ApplicationRecord
  before_create :set_token

  has_many :photo_album_names
  has_many :pictures
  has_many :plans

  def set_token
    loop do
      self.authentication_token = SecureRandom.base64(16)
      break unless User.find_by(:authentication_token => authentication_token)
    end
  end

  def reset_token
    set_token
    save
  end
end
