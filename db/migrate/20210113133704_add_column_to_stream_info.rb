class AddColumnToStreamInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :stream_infos, :fname, :string,comment: '直播保存的文件的名称'
    add_column :stream_infos, :persistentID, :string, comment: '直播保存的文件的ID'
  end
end
