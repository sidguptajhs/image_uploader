class AddThumbDataToImage < ActiveRecord::Migration
  def change
    add_column :images, :thumb_data, :binary
  end
end
