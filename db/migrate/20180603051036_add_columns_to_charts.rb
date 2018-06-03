class AddColumnsToCharts < ActiveRecord::Migration[5.1]
  def change
    rename_column :charts, :content, :project_name
    add_column :charts, :start_date, :datetime
    add_column :charts, :end_date, :datetime
    add_column :charts, :show_main_gridlines, :boolean
    add_column :charts, :show_sub_gridlines, :boolean
    add_column :charts, :row_spacing, :integer
    add_column :charts, :rows, :text, array:true, default: []
  end
end