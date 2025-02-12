# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_02_21_102125) do
  create_table "attendees", force: :cascade do |t|
    t.string "Email"
    t.string "Password"
    t.string "name"
    t.string "Phone_number"
    t.text "Address"
    t.string "Credit_card_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_tickets", force: :cascade do |t|
    t.integer "Attendee_id", null: false
    t.integer "Event_id", null: false
    t.integer "Room_id", null: false
    t.string "confirmation_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "no_of_tickets"
    t.integer "recipient_id"
    t.index ["Attendee_id"], name: "index_event_tickets_on_Attendee_id"
    t.index ["Event_id"], name: "index_event_tickets_on_Event_id"
    t.index ["Room_id"], name: "index_event_tickets_on_Room_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "Name"
    t.integer "Room_id", null: false
    t.string "category"
    t.date "date"
    t.time "start_time"
    t.time "end_time"
    t.decimal "ticket_price"
    t.integer "seats_left"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_capacity"
    t.index ["Room_id"], name: "index_events_on_Room_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "Attendee_id", null: false
    t.integer "Event_id", null: false
    t.integer "rating"
    t.text "feedback"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["Attendee_id"], name: "index_reviews_on_Attendee_id"
    t.index ["Event_id"], name: "index_reviews_on_Event_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "Room_location"
    t.integer "Room_capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "event_tickets", "Attendees"
  add_foreign_key "event_tickets", "Events"
  add_foreign_key "event_tickets", "Rooms"
  add_foreign_key "events", "Rooms"
  add_foreign_key "reviews", "Attendees"
  add_foreign_key "reviews", "Events"
end
