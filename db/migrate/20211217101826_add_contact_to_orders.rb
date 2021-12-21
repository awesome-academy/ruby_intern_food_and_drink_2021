class AddContactToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :role, :integer, default:0
  end
end
