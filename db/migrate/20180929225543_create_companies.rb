class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :website
      t.text :address
      t.integer :employee_count
      t.integer :foundation_year
      t.string :revenue
      t.text :synopsis

      t.timestamps
    end
  end
end
