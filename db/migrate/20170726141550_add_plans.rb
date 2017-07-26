class AddPlans < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :user_id, :integer
    add_column :plans, :photo_album_name_id, :integer
  end
end
