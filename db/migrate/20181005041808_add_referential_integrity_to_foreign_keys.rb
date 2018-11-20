class AddReferentialIntegrityToForeignKeys < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key "househunters",column: "users_id"
    remove_foreign_key "houses",  column: "companies_id"
    remove_foreign_key "inquiries",  column: "househunters_id"
    remove_foreign_key "inquiries", column: "houses_id"
    remove_foreign_key "realtors",  column: "companies_id"
    remove_foreign_key "realtors", column: "users_id"
    remove_foreign_key "realtors_houses", column: "houses_id"
    remove_foreign_key "realtors_houses",column: "realtors_id"

    add_foreign_key "househunters", "users", column: "users_id" , on_delete: :cascade
    add_foreign_key "houses", "companies", column: "companies_id", on_delete: :cascade
    add_foreign_key "inquiries", "househunters", column: "househunters_id" , on_delete: :cascade
    add_foreign_key "inquiries", "houses", column: "houses_id", on_delete: :cascade
    add_foreign_key "realtors", "companies", column: "companies_id", on_delete: :nullify
    add_foreign_key "realtors", "users", column: "users_id", on_delete: :cascade
    add_foreign_key "realtors_houses", "houses", column: "houses_id", on_delete: :cascade
    add_foreign_key "realtors_houses", "realtors", column: "realtors_id", on_delete: :cascade
  end
end
