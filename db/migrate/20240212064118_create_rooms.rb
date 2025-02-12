class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :Room_location
      t.integer :Room_capacity

      t.timestamps
    end
  end
end
