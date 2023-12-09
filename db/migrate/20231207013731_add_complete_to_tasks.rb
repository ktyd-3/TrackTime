class AddCompleteToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :complete, :integer, default: 0
  end
end
