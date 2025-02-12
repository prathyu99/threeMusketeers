class AddNoOfTicketsToEventTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :event_tickets, :no_of_tickets, :integer
  end
end
