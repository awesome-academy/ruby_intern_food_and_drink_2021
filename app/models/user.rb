class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  USER_ATTRS = %i(name email phone address
                   password password_confirmation remember_me).freeze
  has_many :orders, dependent: :destroy
  has_many :favorites, dependent: :destroy
  before_save :downcase_email

  validates :name, presence: true, length:
    {
      minimum: Settings.len_min,
      maximum: Settings.len_max
    }
  validates :email, presence: true, uniqueness: true,
    length: {maximum: Settings.len_max},
    format: {with: Settings.email_regex}
  validates :phone, presence: true, length:
    {
      minimum: Settings.len_min
    }
  validates :address, presence: true, length:
    {
      minimum: Settings.len_min
    }

  def all_orders
    orders.recent_orders
  end

  private
  def downcase_email
    email.downcase!
  end
end
