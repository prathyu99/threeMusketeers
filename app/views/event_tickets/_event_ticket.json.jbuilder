json.extract! event_ticket, :id, :Attendee_id, :Event_id, :Room_id, :confirmation_number, :no_of_tickets, :created_at, :updated_at
json.url event_ticket_url(event_ticket, format: :json)
