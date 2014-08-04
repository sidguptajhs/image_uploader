class AddBinaryDataToImage < ActiveRecord::Migration
  def change
    add_column :images, :data, :binary
  end
end
