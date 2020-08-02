class CreateTrails < ActiveRecord::Migration[6.0]
  def change
    create_table :trails do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :lat
      t.string :lon
      t.integer :order

      t.timestamps
    end
  end
end
