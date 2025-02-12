class CreateAttendees < ActiveRecord::Migration[7.0]
  def change
    create_table :attendees do |t|
      t.string :Email
      t.string :Password
      t.string :name
      t.string :Phone_number
      t.text :Address
      t.string :Credit_card_info

      t.timestamps
    end
  end
end
