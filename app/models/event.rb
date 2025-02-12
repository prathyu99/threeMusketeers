class Event < ApplicationRecord
  belongs_to :Room, foreign_key: 'Room_id', class_name: 'Room'
  has_many :event_tickets, dependent: :destroy
  has_many :Attendees, through: :event_tickets
  has_many :reviews, dependent: :destroy

  validates :event_capacity, numericality: { greater_than_or_equal_to: 1 }
  validate :start_time_must_be_before_end_time
  validate :capacity_does_not_exceed_room_capacity
  validate :check_capacity_with_existing_events
  validate :no_overlapping_events

  #callbacks
  before_create :set_initial_seats_left
  before_save :update_seats_left,  if: -> { event_capacity_changed? || new_record? }

  private

  # Ensure there are no overlapping events in the same room
  def no_overlapping_events
    room = self.Room
    return unless room.present? && date.present? && start_time.present? && end_time.present?

    # Find overlapping events in the same room
    overlapping_events = room.events
                             .where.not(id: id) # Exclude current event if it's being updated
                             .where(date: date)
                             .where.not('start_time >= :end_time OR end_time <= :start_time', start_time: start_time, end_time: end_time)

    if overlapping_events.exists?
      errors.add(:base, "There is already an event scheduled in this room during the selected time slot.")
    end
  end

  private

  def set_initial_seats_left
    self.seats_left = self.event_capacity
  end

  def update_seats_left
    self.seats_left = self.event_capacity - event_tickets.count
  end

  # def start_time_must_be_before_end_time
  #   return if start_time.blank? || end_time.blank?
  #   if start_time >= end_time
  #     errors.add(:start_time, "must be before the end time")
  #   end
  # end
  def start_time_must_be_before_end_time
    return if start_time.blank? || end_time.blank?
    errors.add(:start_time, "must be before end time") if start_time >= end_time
  end

  # def capacity_does_not_exceed_room_capacity
  #   room=self.Room
  #   if event_capacity && event_capacity > room.Room_capacity
  #     errors.add(:event_capacity, "of #{event_capacity} exceeds the room's capacity of #{room.Room_capacity}. Please enter a lower value.")
  #   end
  # end
  def capacity_does_not_exceed_room_capacity
    room=self.Room
    return unless room.present? && event_capacity.present?
    errors.add(:event_capacity, "exceeds the room's capacity of #{room.Room_capacity}") if event_capacity > room.Room_capacity
  end

  def check_capacity_with_existing_events
    room=self.Room
    return unless room.present? && date.present? && start_time.present? && end_time.present? && event_capacity.present?
    overlapping_events = room.events
                             .where.not(id: id)
                             .where(date: date)
                             .where('NOT (start_time >= ? OR end_time <= ?)', end_time, start_time)

    total_capacity = overlapping_events.sum(:event_capacity) + event_capacity
    if total_capacity > room.Room_capacity
      errors.add(:base, "Total capacity for this time slot exceeds the room's capacity")
    end
  end
end

