class RenameTypeToTransactionType < ActiveRecord::Migration[5.1]
  def change
    rename_column :transactions, :type, :transaction_type
  end
end
