class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.belongs_to :parking_space, index: true
      t.string :original
      t.string :square_large
      t.timestamps null: false
    end
  end
end
