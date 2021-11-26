class Category < ApplicationRecord
  ATTR_CHANGE = %i(category_name).freeze
  has_many :foods, dependent: :destroy
  validates :category_name, presence: true, uniqueness: true,
                    length: {maximum: Settings.length.lenth_max}
end
