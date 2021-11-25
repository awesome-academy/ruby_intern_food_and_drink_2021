class User < ApplicationRecord
  ATTR_CHANGE = %i(name email password password_confirmation).freeze
  attr_accessor :remember_token
  has_many :orders, dependent: :destroy
  has_many :favorites, dependent: :destroy
  before_save :downcase_email

  validates :name, presence: true, length:
    {
      minimum: Settings.length.min_5,
      maximum: Settings.length.max_100
    }
  validates :email, presence: true, uniqueness: true,
    length: {maximum: Settings.length.max_100},
    format: {with: Settings.email_regex}
  validates :password, presence: true,
    length: {minimum: Settings.length.min_5}, allow_nil: true
  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password? token
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def all_orders
    orders.recent_orders
  end

  private
  def downcase_email
    email.downcase!
  end
end
