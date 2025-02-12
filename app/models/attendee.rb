class Attendee < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :event_tickets, dependent: :destroy
  has_many :reviews, dependent: :destroy
end