class CreateRealtorsHouse < ActiveRecord::Migration[5.2]
  def change
    create_table :realtors_houses do |t|
      t.references :realtors, {index: true, foreign_key: true}
      t.references :houses, {index: true, foreign_key: true}
    end
  end
end
