class CreateStream < ActiveRecord::Migration[5.0]
  def change
    create_table :streams do |t|
      t.string :name, comment: '流名字'
      t.string :live_name, comment: '直播名称'
      t.datetime :start_time, comment: '开始时间'
      t.datetime :end_time, comment: '结束时间' 
      t.string :push_url, comment: '推流地址'
      t.string :pull_url, comment: '拉流地址'

      t.timestamps
    end
  end
end
