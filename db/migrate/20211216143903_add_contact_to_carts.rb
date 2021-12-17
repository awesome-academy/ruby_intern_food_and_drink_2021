class AddContactToCarts < ActiveRecord::Migration[6.1]
  def change
    add_column :carts, :total, :decimal
  end
end
