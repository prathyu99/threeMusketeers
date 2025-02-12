require "application_system_test_case"

class EventTicketsTest < ApplicationSystemTestCase
  setup do
    @event_ticket = event_tickets(:one)
  end

  test "visiting the index" do
    visit event_tickets_url
    assert_selector "h1", text: "Event tickets"
  end

  test "should create event ticket" do
    visit event_tickets_url
    click_on "New event ticket"

    fill_in "Attendee", with: @event_ticket.Attendee_id
    fill_in "Event", with: @event_ticket.Event_id
    fill_in "Room", with: @event_ticket.Room_id
    fill_in "Confirmation number", with: @event_ticket.confirmation_number
    click_on "Create Event ticket"

    assert_text "Event ticket was successfully created"
    click_on "Back"
  end

  test "should update Event ticket" do
    visit event_ticket_url(@event_ticket)
    click_on "Edit this event ticket", match: :first

    fill_in "Attendee", with: @event_ticket.Attendee_id
    fill_in "Event", with: @event_ticket.Event_id
    fill_in "Room", with: @event_ticket.Room_id
    fill_in "Confirmation number", with: @event_ticket.confirmation_number
    click_on "Update Event ticket"

    assert_text "Event ticket was successfully updated"
    click_on "Back"
  end

  test "should destroy Event ticket" do
    visit event_ticket_url(@event_ticket)
    click_on "Destroy this event ticket", match: :first

    assert_text "Event ticket was successfully destroyed"
  end
end
