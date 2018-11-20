class RefineReferentialIntegrities < ActiveRecord::Migration[5.2]
  def change
      change_column :houses, :realtor_id, :bigint
      add_foreign_key "houses", "realtors", column: "realtor_id", on_delete: :cascade
      change_column :interested_househunters, :house_id, :bigint
      change_column :interested_househunters, :househunter_id, :bigint
      add_foreign_key "interested_househunters", "houses", column: "house_id", on_delete: :cascade
      add_foreign_key "interested_househunters", "househunters", column: "househunter_id", on_delete: :cascade
  end
end
