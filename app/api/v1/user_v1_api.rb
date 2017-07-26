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
  end
  post 'create' do
    openid = headers['Openid']
    user = User.find_or_create_by(:openid => openid)
    present :user ,user,with: Entities::User
  end
  # desc '获取商品列表' do
  #   detail '可用于搜索,可通过店铺ID,二级分类ID,标题(模糊)搜索商品'
  #   #success Entities::Product
  #   headers "Authentication-Token": {description: '用户token', required: false}
  # end
  # params do
  #   optional :userinfo_id, allow_blank: false, type: String, desc: '店铺id'
  #   optional :category_id, allow_blank: false, type: String, desc: '二级分类id'
  #   optional :title, type: String, desc: '标题'
  #   optional :order_field, type: Symbol, values: [:price, :sale_count], desc: '排序字段'
  #   optional :order_asc, type: Symbol, default: :asc, values: [:asc, :desc], desc: '排序顺序'
  # end
  # paginate per_page: 10, offset: false
  # get '/' do
  #   title = params.delete(:title)
  #   order_field = params.delete(:order_field)
  #   order_asc = params.delete(:order_asc)
  #
  #   products = Product.online.where(params.slice(:userinfo_id, :category_id))
  #   products = products.where(title: /#{title}/) if title.present?
  #   products = products.order("#{order_field} #{order_asc}") if order_field.present?
  #
  #   status 200
  #   products = paginate(products)
  #   #present :total_count, products.total_count
  #   #present :products, products, with: Entities::Product, user: current_user
  # end
end