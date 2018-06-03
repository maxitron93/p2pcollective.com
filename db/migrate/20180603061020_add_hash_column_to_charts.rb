class AddHashColumnToCharts < ActiveRecord::Migration[5.1]
  def change
    remove_column :charts, :rows
    enable_extension 'hstore' unless extension_enabled?('hstore')
    add_column :charts, :rows, :hstore, array:true, default: []
  end
end
