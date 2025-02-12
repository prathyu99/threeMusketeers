class AddRecipientIdToEventTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :event_tickets, :recipient_id, :integer
  end
end
