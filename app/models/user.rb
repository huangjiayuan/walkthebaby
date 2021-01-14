class User < ApplicationRecord
  before_create :set_token

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
