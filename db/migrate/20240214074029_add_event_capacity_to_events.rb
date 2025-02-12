class AddEventCapacityToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :event_capacity, :integer
  end
end
