class PhotoAlbumName < ApplicationRecord
  belongs_to :user
  has_many :pictures
  has_one :plan
end
