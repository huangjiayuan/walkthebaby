require 'grape'
require 'grape-swagger'
class UserV1API < Grape::API
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

  desc '用户登陆/注册' do
    detail '用户登录时,用户已注册,直接登录;用户未注册,则注册后登录'
    success Entities::User
    headers "Authentication-Token": {description: '用户token', required: false},"Openid":{description: '微信ID', required: false}
  end
  params do
    requires :name, type: String, desc: '用户微信昵称'
  end
  post 'create' do
    openid = headers['Openid']
    user = User.find_or_create_by(:openid => openid)
    user.update(params["name"]) if user.name != params["name"]
    status 201
    present :user ,user, with: Entities::User
  end
end