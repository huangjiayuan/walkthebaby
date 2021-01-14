require 'grape'
require 'grape-swagger'
class StreamV1API < Grape::API
  include Grape::Kaminari
  format :json

  helpers do
    def current_user
      token = headers['Authentication-Token']
      openid = headers['Openid']
      error!('Token不存在!', 422) if token.blank?
      #binding.pry
      user = User.find_by(:openid => openid)
      if ActiveSupport::SecurityUtils.secure_compare(user.authentication_token,token)
        user
      else
        error!('401 Unauthorized', 401)
      end
    rescue
      error!('header错误!', 401)
    end

    def authenticate!
      error!('401 Unauthorized', 401) unless current_user
      current_user
    end
  end

  desc '直播列表' do
    detail '获取直播列表'
    success Entities::Notice
    headers "Authentication-Token": {
      description: '用户token', required: false},
      "Openid":{description: '微信ID', required: false}
  end
  params do
  end
  paginate per_page: 10, offset: false
  get 'index' do
    streams = Stream.all
    status 200
    present :notice, paginate(streams), with: Entities::Stream
  end

end
