class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email_id
      t.string :password
      t.boolean :is_admin
      t.boolean :is_realtor
      t.boolean :is_househunter

      t.timestamps
    end
  end
end
