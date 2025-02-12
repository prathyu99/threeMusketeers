require "test_helper"

class EventTicketsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event_ticket = event_tickets(:one)
  end

  test "should get index" do
    get event_tickets_url
    assert_response :success
  end

  test "should get new" do
    get new_event_ticket_url
    assert_response :success
  end

  test "should create event_ticket" do
    assert_difference("EventTicket.count") do
      post event_tickets_url, params: { event_ticket: { Attendee_id: @event_ticket.Attendee_id, Event_id: @event_ticket.Event_id, Room_id: @event_ticket.Room_id, confirmation_number: @event_ticket.confirmation_number } }
    end

    assert_redirected_to event_ticket_url(EventTicket.last)
  end

  test "should show event_ticket" do
    get event_ticket_url(@event_ticket)
    assert_response :success
  end

  test "should get edit" do
    get edit_event_ticket_url(@event_ticket)
    assert_response :success
  end

  test "should update event_ticket" do
    patch event_ticket_url(@event_ticket), params: { event_ticket: { Attendee_id: @event_ticket.Attendee_id, Event_id: @event_ticket.Event_id, Room_id: @event_ticket.Room_id, confirmation_number: @event_ticket.confirmation_number } }
    assert_redirected_to event_ticket_url(@event_ticket)
  end

  test "should destroy event_ticket" do
    assert_difference("EventTicket.count", -1) do
      delete event_ticket_url(@event_ticket)
    end

    assert_redirected_to event_tickets_url
  end
end
