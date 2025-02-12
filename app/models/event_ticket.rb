class EventTicket < ApplicationRecord
  belongs_to :Attendee, class_name: 'Attendee', foreign_key: 'Attendee_id'
  belongs_to :Event, class_name: 'Event', foreign_key: 'Event_id'
  belongs_to :Room, class_name: 'Room', foreign_key: 'Room_id'
  belongs_to :recipient, class_name: 'Attendee', foreign_key: 'recipient_id', optional: true
  has_one :room, through: :event
  # If Attendee_id is the buyer
  belongs_to :buyer, class_name: 'Attendee', foreign_key: 'Attendee_id'
  attr_accessor :Attendee_email
  validate :attendee_email_must_match_id

  private

  def attendee_email_must_match_id
    # Find the attendee by email
    attendee = Attendee.find_by(email: self.Attendee_email)
    unless attendee && attendee.id == self.Attendee_id
      errors.add(:Attendee_email, 'does not match any existing attendee ID')
    end
  end

end
