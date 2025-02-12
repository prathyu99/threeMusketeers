class CreateEventTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :event_tickets do |t|
      t.references :Attendee, null: false, foreign_key: true
      t.references :Event, null: false, foreign_key: true
      t.references :Room, null: false, foreign_key: true
      t.string :confirmation_number

      t.timestamps
    end
  end
end
