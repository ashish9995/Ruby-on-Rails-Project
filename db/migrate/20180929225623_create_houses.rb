class CreateHouses < ActiveRecord::Migration[5.2]
  def change
    create_table :houses do |t|
      t.references :companies, {index: true, foreign_key: true}
      t.text :location
      t.string :area
      t.integer :year_built
      t.string :style
      t.integer :list_prize
      t.integer :floor_count
      t.boolean :basement
      t.string :owner_name

      t.timestamps
    end
  end
end
