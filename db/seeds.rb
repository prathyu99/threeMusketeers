# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Clear existing records to avoid duplication
Attendee.destroy_all
Event.destroy_all
Room.destroy_all
EventTicket.destroy_all
Review.destroy_all

Attendee.create!(
  Email: 'admin123@gmail.com',
  Password: 'admin123',
  name: 'Admin User',
  Phone_number: '1234567890',
  Address: '123 Admin Street',
  Credit_card_info: '0000-0000-0000-0000'# Fake for demonstration
)

# Attendees
attendees = Attendee.create([
                              { Email: 'john.doe@example.com', Password: 'password123', name: 'John Doe', Phone_number: '123-456-7890', Address: '123 Main St, Anytown, USA', Credit_card_info: '1111-2222-3333-4444' },
                              { Email: 'jane.smith@example.com', Password: 'password456', name: 'Jane Smith', Phone_number: '987-654-3210', Address: '456 Oak St, Anycity, USA', Credit_card_info: '5555-6666-7777-8888' }
                            ])

# Rooms
rooms = Room.create([
                      { Room_location: 'Conference Hall A', Room_capacity: 200 },
                      { Room_location: 'Meeting Room 1', Room_capacity: 50 }
                    ])

# Events
events = Event.create([
                        { Name: 'Tech Conference 2024', Room_id: rooms.first.id, category: 'Technology', date: Date.new(2024, 3, 10), start_time: Time.parse('10:00'), end_time: Time.parse('18:00'), ticket_price: 99.99, seats_left: 150 },
                        { Name: 'Local Music Festival', Room_id: rooms.second.id, category: 'Music', date: Date.new(2024, 4, 20), start_time: Time.parse('12:00'), end_time: Time.parse('23:00'), ticket_price: 49.99, seats_left: 45 }
                      ])

# Event Tickets
event_tickets = EventTicket.create([
                                     { Attendee_id: attendees.first.id, Event_id: events.first.id, Room_id: rooms.first.id, confirmation_number: 'CONF123456' },
                                     { Attendee_id: attendees.second.id, Event_id: events.second.id, Room_id: rooms.second.id, confirmation_number: 'CONF654321' }
                                   ])

# Reviews
reviews = Review.create([
                          { Attendee_id: attendees.first.id, Event_id: events.first.id, rating: 5, feedback: 'Amazing experience, highly recommend!' },
                          { Attendee_id: attendees.second.id, Event_id: events.second.id, rating: 4, feedback: 'Great music and vibes, but the food was a bit pricey.' }
                        ])

puts "Seed data created."
