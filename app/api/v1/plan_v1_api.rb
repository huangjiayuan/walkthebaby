require 'grape'
require 'grape-swagger'
class PlanV1API < Grape::API
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

  desc '创建/变更计划' do
    detail '创建新的计划时id不传值,变更计划时,id传需要变更的计划的id'
    success Entities::Plan
    headers "Authentication-Token": {description: '用户token', required: false},"Openid":{description: '微信ID', required: false}
  end
  params do
    requires 'title', type: String, desc: '标题'
    requires 'destination', type: String, desc: '目的地'
    requires 'vehicle', type: Symbol, default: :self_driving, values: [:self_driving,:public_transport], desc: 'self_driving:自驾, public_transport:公共交通'
    optional 'strategy', type: String, desc: '攻略'
    requires 'date', type: Date, desc: '时间'
    optional 'id', type: Integer, desc: 'id'
  end
  post 'create' do
    authenticate!

    if params[:id].present?
      plan = current_user.plans.find(params.delete('id'))
    else
      phan = PhotoAlbumName.create(:user_id => current_user.id,:name => params[:title])
      plan = Plan.create(:user_id => current_user.id,:photo_album_name_id => phan.id)
    end
    plan.update(params)
    status 201
    present :plan ,plan,with: Entities::Plan
  end


  desc '删除计划' do
    detail '删除计划'
    success Entities::Plan
    headers "Authentication-Token": {description: '用户token', required: false},"Openid":{description: '微信ID', required: false}
  end
  params do
    requires 'id', type: Integer, desc: 'id'
  end
  post 'destroy' do
    authenticate!

    current_user.plans.find(params[:id]).destroy
    status 201
    {"msg":"ok"}
  end


  desc '查找计划'do
    detail '删除计划'
    success Entities::Plan
    headers "Authentication-Token": {description: '用户token', required: false},"Openid":{description: '微信ID', required: false}
  end

  params do
    optional 'id', type: Integer, desc: 'id'
    optional 'title', type: String, desc: '标题'
    optional 'destination', type: String, desc: '目的地'
    optional 'vehicle', type: String, desc: 'self_driving:自驾, public_transport:公共交通'
  end
  paginate per_page: 10, offset: false
  get '' do
    plans = Plan.all
    plans = plans.where(params) if params[:id].present? || params[:title].present? || params[:destination].present? ||params[:vehicle].present?
    status 201
    binding.pry
    present :plans, paginate(plans), with: Entities::Plan
    #present :plans, plans, with: Entities::Plan
  end
end
