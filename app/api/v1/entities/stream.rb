module Entities
    class Stream < Grape::Entity
      expose :id, documentation: {type: Integer, desc: '唯一识别码'}
      expose :live_name, documentation: {type: String, desc: '直播名称'}
      expose :start_time, documentation: {type: String, desc: '开始时间'}
      expose :end_time, documentation: {type: String, desc: '结束时间'}
      expose :pull_url, documentation: {type: String, desc: '播放流'}
      expose :updated_at, documentation: {type: Date, desc: '创建时间'}
    end
  end