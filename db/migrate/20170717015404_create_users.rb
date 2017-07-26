class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :openid
      t.string :authentication_token
      t.timestamps
    end
  end
end
