class AddContactToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :phone, :string,  null: false
    add_column :users, :address, :string,  null: false
  end
end
