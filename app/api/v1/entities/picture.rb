module Entities
  class Picture < Grape::Entity
    expose :id, documentation: {type: Integer, desc: 'id'}
    expose :user_id, documentation: {type: Integer, desc: '用户ID'}
    expose :photo_album_name_id, documentation: {type: Integer, desc: '相册ID'}
    expose :url, documentation: {type: String, desc: '图片url'} do |pic,options|
      QiniuConfig.full_url(pic.url)
    end
  end
end