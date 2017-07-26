require 'grape'
require 'grape-swagger'
class WalkV1Api < Grape::API
  mount UserV1API => 'user'
  mount PhotoAlbumV1API => 'photo_album'
  mount PictureV1API => 'picture'
  mount PlanV1API => 'plan'

  add_swagger_documentation base_path: '/api/v1',
                            hide_format: true ,
                            doc_version: '1.0.0',
                            info:{
                                title:'API',
                                description:'API接口文档',
                                contact_name:'元',
                                contact_email:'jiayuan_huang@163.com',
                                license: "一起溜娃and晒娃吧!"
                            }
end