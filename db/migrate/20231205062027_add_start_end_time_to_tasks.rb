class AddStartEndTimeToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :start_time, :datetime
    add_column :tasks, :end_time, :datetime
  end
end
