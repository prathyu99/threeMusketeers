require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase
  setup do
    @event = events(:one)
  end

  test "visiting the index" do
    visit events_url
    assert_selector "h1", text: "Events"
  end

  test "should create event" do
    visit events_url
    click_on "New event"

    fill_in "Name", with: @event.Name
    fill_in "Room", with: @event.Room_id
    fill_in "Category", with: @event.category
    fill_in "Date", with: @event.date
    fill_in "End time", with: @event.end_time
    fill_in "Seats left", with: @event.seats_left
    fill_in "Start time", with: @event.start_time
    fill_in "Ticket price", with: @event.ticket_price
    click_on "Create Event"

    assert_text "Event was successfully created"
    click_on "Back"
  end

  test "should update Event" do
    visit event_url(@event)
    click_on "Edit this event", match: :first

    fill_in "Name", with: @event.Name
    fill_in "Room", with: @event.Room_id
    fill_in "Category", with: @event.category
    fill_in "Date", with: @event.date
    fill_in "End time", with: @event.end_time
    fill_in "Seats left", with: @event.seats_left
    fill_in "Start time", with: @event.start_time
    fill_in "Ticket price", with: @event.ticket_price
    click_on "Update Event"

    assert_text "Event was successfully updated"
    click_on "Back"
  end

  test "should destroy Event" do
    visit event_url(@event)
    click_on "Destroy this event", match: :first

    assert_text "Event was successfully destroyed"
  end
end
