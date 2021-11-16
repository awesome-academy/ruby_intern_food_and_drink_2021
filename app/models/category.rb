class Category < ApplicationRecord
  has_many :foods, dependent: :destroy
end
