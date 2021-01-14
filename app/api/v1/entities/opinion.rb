module Entities
    class Opinion < Grape::Entity
      expose :id, documentation: {type: Integer, desc: '唯一识别码'}
      expose :title, documentation: {type: String, desc: '标题'}
      expose :create_user_id, documentation: {type: String, desc: '建议人ID'}
      expose :create_user_name, documentation: {type: String, desc: '建议人'}
      expose :doc, documentation: {type: String, desc: '建议内容'}
      expose :updated_at, documentation: {type: Date, desc: '最后修改/创建时间'}
    end
  end