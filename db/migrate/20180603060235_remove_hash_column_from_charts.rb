class RemoveHashColumnFromCharts < ActiveRecord::Migration[5.1]
  def change
    remove_column :charts, :rows
    add_column :charts, :rows, :text, array:true, default: []
  end
end
