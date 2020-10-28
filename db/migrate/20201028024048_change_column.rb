class ChangeColumn < ActiveRecord::Migration[6.0]
  def change
    change_column :robots, :orientation, :integer
  end
end
