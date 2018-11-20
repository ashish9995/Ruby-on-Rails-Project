class SupportGoogleOauth < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :provider, :string
    add_column :users, :auth_uid, :string
  end
end
