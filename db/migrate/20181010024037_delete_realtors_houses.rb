class DeleteRealtorsHouses < ActiveRecord::Migration[5.2]
  def change
    drop_table :realtors_houses
  end
end
