class Review < ApplicationRecord
  belongs_to :Attendee
  belongs_to :Event
end
