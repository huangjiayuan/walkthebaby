module Entities
  class User < Grape::Entity
    expose :openid, documentation: {type: String, desc: '微信唯一识别码'}
    expose :authentication_token, documentation: {type: String, desc: 'token'}
    expose :name, documentation: {type: String, desc: '微信昵称'}
  end
end