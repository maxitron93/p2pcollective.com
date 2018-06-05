class AddColumnsToChart < ActiveRecord::Migration[5.1]
  def change
    remove_column :charts, :show_main_gridlines
    remove_column :charts, :show_sub_gridlines
    remove_column :charts, :start_date
    remove_column :charts, :end_date
    add_column :charts, :container_width, :integer
    add_column :charts, :start_date, :integer
    add_column :charts, :end_date, :integer
  end
end
