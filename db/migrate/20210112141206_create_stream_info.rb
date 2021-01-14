class CreateStreamInfo < ActiveRecord::Migration[5.0]
  def change
    create_table :stream_infos do |t|
      t.integer :stream_id
      t.string :live_name, comment: '直播名称'
      t.integer :start_time, comment: '开始时间'
      t.integer :end_time, comment: '结束时间'
      t.string :client_iP, comment: '客户端IP'
      t.string :server_iP, comment: '服务端IP'

      t.timestamps
    end
  end
end
