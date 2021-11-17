class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :phone, null:false
      t.string :address, null: false
      t.integer :status,null:false, default:0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :orders, [:user_id, :created_at]
  end
end
