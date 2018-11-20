class CreateRealtors < ActiveRecord::Migration[5.2]
  def change
    create_table :realtors do |t|
      t.string :first_name
      t.string :last_name
      t.integer :companies_id
      t.integer :phone_number
      t.references :users, index: true, foreign_key: true
      t.references :companies, index: true, foreign_key: true

      t.timestamps
    end
  end
end
