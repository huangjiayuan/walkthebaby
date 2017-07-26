class CreatePhotoAlbumNames < ActiveRecord::Migration[5.0]
  def change
    create_table :photo_album_names do |t|
      t.text :name
      t.integer :user_id

      t.timestamps
    end
  end
end
