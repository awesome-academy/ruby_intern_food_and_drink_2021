class Food < ApplicationRecord
  belongs_to :category
  has_many :carts, dependent: :destroy
end
