require 'grape'
require 'grape-swagger'
class PhotoAlbumV1API < Grape::API
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

  desc '创建相册' do
    detail '用户创建相册'
    success Entities::PhotoAlbumName
    headers "Authentication-Token": {description: '用户token', required: false},"Openid":{description: '微信ID', required: false}
  end
  params do
    requires :name, type: String, desc: '相册名称'
  end
  post 'create_name' do
    authenticate!
    #bug from
    #params.permit!
    #PhotoAlbumName.create(params)
    #ActiveModel::ForbiddenAttributesError
    #bug end
    photo_album = PhotoAlbumName.create(:user_id => current_user.id,:name => params[:name])
    status 201
    present :photo_album ,photo_album,with: Entities::PhotoAlbumName

  end

  desc '删除相册' do
    detail '用户删除相册'
    success Entities::PhotoAlbumName
    headers "Authentication-Token": {description: '用户token', required: false},"Openid":{description: '微信ID', required: false}
  end
  params do
    requires :photo_album_name_id, type: String, desc: '相册id'
    requires :name, type: String, desc: '相册名称'
  end
  post 'update_name' do
    authenticate!
    photo_album = PhotoAlbumName.find(params[:photo_album_name_id])
    photo_album.pictures.each do |pic|
      res = QiniuConfig.delete_file(pic.url)
      pic.destroy if res[:code] == 200
    end
    photo_album.destroy if photo_album.pictures.count == 0
    status 201
    present :photo_album ,photo_album,with: Entities::PhotoAlbumName
  end

  desc '修改相册名字' do
    detail '用户修改相册名字'
    success Entities::PhotoAlbumName
    headers "Authentication-Token": {description: '用户token', required: false},"Openid":{description: '微信ID', required: false}
  end
  params do
    requires :photo_album_name_id, type: String, desc: '相册id'
    requires :name, type: String, desc: '相册名称'
  end
  post 'update_name' do
    authenticate!
    PhotoAlbumName.find(params[:photo_album_name_id]).update(:name => params[:name])
    photo_album = PhotoAlbumName.find(params[:photo_album_name_id])
    status 201
    present :photo_album ,photo_album,with: Entities::PhotoAlbumName
  end

  desc '获取相册名字' do
    detail '用户获取相册名字'
    success Entities::PhotoAlbumName
    headers "Authentication-Token": {description: '用户token', required: false},"Openid":{description: '微信ID', required: false}
  end
  params do
    # optional :key, type: Symbol, default: :id, values: [:id, :name], desc: 'id:相册id，name:相册名称'
    # optional :value, type: String, desc: 'key对应的值'
    optional :id,type: Integer, desc:'相册id'
    optional :name,type: String, desc:'相册名称'
  end
  paginate per_page: 10, offset: false
  get '' do
    authenticate!
    photo_albums = PhotoAlbumName.where(params)
    status 201
    present :photo_album ,paginate(photo_albums),with: Entities::PhotoAlbumName
  end

end
