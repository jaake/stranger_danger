class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :tag_1
      t.string :tag_2
      t.string :tag_3
      t.timestamps
    end
  end
end
