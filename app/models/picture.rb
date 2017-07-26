class Picture < ApplicationRecord
  belongs_to :user
  belongs_to :photo_album_name

end
