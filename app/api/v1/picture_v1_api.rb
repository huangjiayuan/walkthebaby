require 'grape'
require 'grape-swagger'
class PictureV1API < Grape::API
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

  desc '上传照片' do
    detail '上传照片'
    success Entities::Picture
    headers "Authentication-Token": {description: '用户token', required: false},"Openid":{description: '微信ID', required: false}
  end
  params do
    requires :pic, type: File, desc: '照片'
    requires :album_id, type: Integer, desc: '照片'
  end
  post 'upload' do
    file = ActionDispatch::Http::UploadedFile.new(params[:pic])
    res = QiniuConfig.upload(file.path)
    error!('上传失败!') unless res[:code] == 200
    #binding.pry
    pic = Picture.create(:url => res[:result]["key"], :user_id => current_user.id, :photo_album_name_id => params[:album_id] )
    status 201
    present :pic, pic, with: Entities::Picture
  end

  desc '获取照片' do
    detail '获取照片'
    success Entities::Picture
    headers "Authentication-Token": {description: '用户token', required: false},"Openid":{description: '微信ID', required: false}
  end
  params do
    optional :user_id, type: Integer, desc: '用户ID'
    optional :album_id, type: Integer, desc: '相册ID'
  end
  paginate per_page: 10, offset: false
  get '' do
    pictures = current_user.pictures
    pictures = pictures.where(params) if params[:user_id].present? || params[:album_id].present?
    status 201
    present :pic, paginate(pictures), with: Entities::Picture
  end


end

