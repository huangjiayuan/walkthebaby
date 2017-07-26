class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.text :title #标题
      t.text :destination #目的地
      t.text :vehicle #交通方式
      t.text :strategy #攻略
      t.date :date #时间

      t.timestamps
    end
  end
end
