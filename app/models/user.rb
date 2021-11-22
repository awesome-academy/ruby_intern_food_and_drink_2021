class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :favorites, dependent: :destroy

  ATTR_CHANGE = %i(name email password password_confirmation).freeze

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

  private
  def downcase_email
    email.downcase!
  end
end
