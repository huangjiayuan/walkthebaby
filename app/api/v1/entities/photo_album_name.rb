module Entities
  class PhotoAlbumName < Grape::Entity
    expose :name, documentation: {type: String, desc: '相册名称'}
    expose :user, using: Entities::User, documentation:{type:User,desc:'用户'} do |pan,options|
      pan.user
    end
  end
end