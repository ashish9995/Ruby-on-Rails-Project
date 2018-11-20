class AddRealtorIdToHouses < ActiveRecord::Migration[5.2]
  def change
    add_column :houses, :realtor_id, :integer
  end
end
