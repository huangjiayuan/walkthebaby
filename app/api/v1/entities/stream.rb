module Entities
    class Notice < Grape::Entity
      expose :id, documentation: {type: Integer, desc: '唯一识别码'}
      expose :title, documentation: {type: String, desc: '标题'}
      expose :doc, documentation: {type: String, desc: '公告内容'}
      expose :create_user, documentation: {type: String, desc: '发布人'}
      expose :created_at, documentation: {type: Date, desc: '创建时间'}
    end
  end