class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :source
      t.string :username, :unique => true

      t.timestamps
    end
  end
end
