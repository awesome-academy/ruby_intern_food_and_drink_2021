class Order < ApplicationRecord
  belongs_to :user
  has_many :carts, dependent: :destroy
end
