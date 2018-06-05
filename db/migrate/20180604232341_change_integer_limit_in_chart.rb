class ChangeIntegerLimitInChart < ActiveRecord::Migration[5.1]
  def change
    remove_column :charts, :start_date
    remove_column :charts, :end_date
    add_column :charts, :start_date, :integer, limit: 8
    add_column :charts, :end_date, :integer, limit: 8
  end
end
