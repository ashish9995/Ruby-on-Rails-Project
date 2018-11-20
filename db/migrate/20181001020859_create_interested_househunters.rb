class CreateInterestedHousehunters < ActiveRecord::Migration[5.2]
  def change
    create_table :interested_househunters do |t|
      t.integer :house_id
      t.integer :househunter_id

      t.timestamps
    end
  end
end
