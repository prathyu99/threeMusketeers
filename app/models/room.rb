class Room < ApplicationRecord
  has_many :events, dependent: :destroy
end
