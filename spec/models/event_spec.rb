require 'rails_helper'

RSpec.describe Event, type: :model do
  # Setup a room and necessary objects for the tests
  let(:room) { Room.create!(Room_location: 'Test Room', Room_capacity: 100) }
  let(:event) do
    room.events.build(
      Name: 'Test Event',
      date: Date.today,
      start_time: Time.now,
      end_time: Time.now + 2.hours,
      event_capacity: 50
    )
  end

  describe 'associations' do
    it { should belong_to(:Room) }
    it { should have_many(:event_tickets).dependent(:destroy) }
    it { should have_many(:Attendees).through(:event_tickets) }
    it { should have_many(:reviews).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:event_capacity).is_greater_than_or_equal_to(1) }

    it 'is not valid if the start_time is after the end_time' do
      event.start_time = Time.now + 3.hours
      event.end_time = Time.now + 2.hours
      expect(event).not_to be_valid
      expect(event.errors[:start_time]).to include('must be before end time')
    end

    it 'is not valid if the event_capacity exceeds Room_capacity' do
      event.event_capacity = room.Room_capacity + 1
      expect(event).not_to be_valid
      expect(event.errors[:event_capacity]).to include('exceeds the room\'s capacity')
    end

    it 'is not valid if the total capacity during the time slot exceeds the room capacity' do
      overlapping_event = room.events.create!(
        Name: 'Overlapping Event',
        date: event.date,
        start_time: event.start_time,
        end_time: event.end_time,
        event_capacity: room.Room_capacity - 10
      )
      expect(event).not_to be_valid
      expect(event.errors[:base]).to include('Total capacity for this time slot exceeds the room\'s capacity')
    end
  end

  describe 'callbacks' do
    it 'sets initial seats left before create' do
      event.save
      expect(event.seats_left).to eq(event.event_capacity)
    end

    it 'updates seats left before save if event_capacity changed' do
      event.save
      event.event_capacity = 25
      event.save
      expect(event.seats_left).to eq(25 - event.event_tickets.count)
    end
  end

  describe 'custom methods' do
    # Add tests for any custom methods you've written in your model
  end
end
