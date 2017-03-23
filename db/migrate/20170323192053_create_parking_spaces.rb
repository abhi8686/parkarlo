class CreateParkingSpaces < ActiveRecord::Migration
  def change
    create_table :parking_spaces do |t|
      t.belongs_to :user, index: true
      t.decimal :latitude
      t.decimal :longitude
      t.integer :cost
      t.boolean :status
      t.timestamps null: false
    end
  end
end
