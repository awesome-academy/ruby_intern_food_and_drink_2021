class Order < ApplicationRecord
  belongs_to :user
  has_many :carts, dependent: :destroy
  has_many :foods, through: :carts
  delegate :name, :email, to: :user, prefix: true
  enum status: {
    open: 0,
    confirmed: 1,
    shipping: 2,
    completed: 3,
    cancelled: 4
  }
  enum role: {
    orders_admin: 0,
    orders_user: 1
  }
  scope :recent_orders, ->{order created_at: :desc}
  ransacker :created_at do
    Arel.sql("date(created_at)")
  end
  validates :phone, presence: true, length:
    {
      minimum: Settings.len_min
    }
  validates :address, presence: true, length:
    {
      minimum: Settings.len_min
    }
  validates :total, presence: true,
  numericality:
  {
    only_integer: false,
    greater_than_or_equal_to: Settings.init_number
  }
end
