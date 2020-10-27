class AddColumnToRobot < ActiveRecord::Migration[6.0]
  def change
    add_column :robots, :on_table, :boolean
  end
end
