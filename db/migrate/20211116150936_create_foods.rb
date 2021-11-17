class CreateFoods < ActiveRecord::Migration[6.1]
  def change
    create_table :foods do |t|
      t.string :name, null: false
      t.decimal :price, null: false
      t.text :description
      t.integer :quantity, null: false
      t.integer :status, null: false, default: 0
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
    add_index :foods, :name
    add_index :foods, :price
  end
 end
