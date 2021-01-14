class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :login_name, comment: '登录名'
      t.string :real_name, comment: '实际名称'  
      t.string :openid, comment: '微信ID'
      t.string  :wx_name, coment: '微信昵称'
      t.string :authentication_token

      t.timestamps
    end

    create_table :notices do |t|
      t.string :title, comment: '标题'  
      t.text :doc, comment: '公告内容'
      t.integer :status, comment: '状态'
      t.boolean :is_first, comment: '是否置顶'
      t.integer :order_no, comment: '排序'
      t.integer :create_user_id, comment: '创建人'
      t.integer :create_user_name, comment: '创建时间'

      t.timestamps
    end  

    create_table :opinions do |t|
      t.string :title, comment: '标题'  
      t.text :doc, comment: '公告内容'
      t.integer :status, comment: '状态'
      t.boolean :is_first, comment: '是否置顶'
      t.integer :order_no, comment: '排序'
      t.integer :create_user_id, comment: '建议人ID'
      t.integer :create_user_name, comment: '建议人'
     
      t.timestamps
    end 
  end
end
