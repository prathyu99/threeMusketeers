json.extract! review, :id, :Attendee_id, :Event_id, :rating, :feedback, :created_at, :updated_at
json.url review_url(review, format: :json)
