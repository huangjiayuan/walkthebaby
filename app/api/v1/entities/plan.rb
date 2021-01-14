module Entities
  class Plan < Grape::Entity
    expose :id, documentation: {type: Integer, desc: '唯一识别码'}
    expose :title, documentation: {type: String, desc: '标题'}
    expose :destination, documentation: {type: String, desc: '目的地'}
    expose :vehicle, documentation: {type: String, desc: '交通方式'}
    expose :strategy, documentation: {type: String, desc: '攻略'}
    expose :date, documentation: {type: Date, desc: '时间'}
  end
end