class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.references :user, foreign_key: true
      t.string :label

      t.timestamps
    end
  end
end
