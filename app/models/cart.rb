class Cart < ApplicationRecord
  belongs_to :order
  belongs_to :food
  delegate :name, to: :food, prefix: true
  delegate :price, to: :food, prefix: true
  scope :find_cart, ->(pr_id){where food_id: pr_id}
end
