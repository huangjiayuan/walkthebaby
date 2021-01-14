require 'grape'
require 'grape-swagger'
class OpinionV1API < Grape::API
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

  desc '意见建议' do
    detail '创建意见建议'
    success Entities::Opinion
    headers "Authentication-Token": {
      description: '用户token', required: false},
      "Openid":{description: '微信ID', required: false}
  end
  params do
    requires :title, type: String, desc: '标题' 
    requires :doc, type: String, desc: '意见内容'
  end
  post 'create' do
    opinion = Opinion.create(params.merge({"create_user_id": current_user.id, "create_user_name": current_user.name}))
    status 200
    present :opinion, opinion, with: Entities::Opinion
  end


  desc '意见建议' do
    detail '获取意见建议列表'
    success Entities::Opinion
    headers "Authentication-Token": {
      description: '用户token', required: false},
      "Openid":{description: '微信ID', required: false}
  end
  params do
  end
  paginate per_page: 10, offset: false
  get 'index' do
    binding.pry
    opinions = Opinion.all
    status 200
    present :opinion, paginate(opinions), with: Entities::Opinion
  end

  desc '意见建议' do
    detail '获取单个意见建议'
    success Entities::Opinion
    headers "Authentication-Token": {
      description: '用户token', required: false},
      "Openid":{description: '微信ID', required: false}
  end
  params do
    requires :id, type: String, desc: '意见建议id'
  end
  paginate per_page: 10, offset: false
  get 'show' do
    opinion = Opinion.find_by_id(params["id"])
    status 200
    present :opinion, paginate(opinion), with: Entities::Notice
  end

  desc '意见建议' do
    detail '修改单个意见建议'
    success Entities::Opinion
    headers "Authentication-Token": {
      description: '用户token', required: false},
      "Openid":{description: '微信ID', required: false}
  end
  params do
    requires :id, type: String, desc: '意见建议id'
    requires :title, type: String, desc: '意见建议标题'
    requires :doc, type: String, desc: '意见建议内容'
  end
  post 'update' do
    opinion = Opinion.find_by_id(params.delete('id'))
    if opinion.parsent? && opinion.create_user_id == current_usert.id
      opinion.update(params)
      status 200
      present :opinion, opinion, with: Entities::Opinion
    else
      {status: 400, msd: '操作有误!'}
    end
  end

  desc '意见建议' do
    detail '删除单个意见建议'
    success Entities::Opinion
    headers "Authentication-Token": {
      description: '用户token', required: false},
      "Openid":{description: '微信ID', required: false}
  end
  params do
    requires :id, type: String, desc: '意见建议id'
  end
  delete 'destroy' do
    opinion = Opinion.find_by_id(params["id"])
    if opinion.parsent? && opinion.create_user_id == current_usert.id
      opinion.destroy
      status 200
      present :opinion, opinion, with: Entities::Opinion
    else
      {status: 400, msd: '操作有误!'}
    end
  end

end
