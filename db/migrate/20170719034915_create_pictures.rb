class CreatePictures < ActiveRecord::Migration[5.0]
  def change
    create_table :pictures do |t|
      t.text :url
      t.integer :user_id
      t.integer :photo_album_name_id

      t.timestamps
    end
  end
end
