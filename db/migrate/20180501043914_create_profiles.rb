class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
