class Food < ApplicationRecord
  ATTR_CHANGE = %i(thumbnail name price description quantity status
                   category_id).freeze
  belongs_to :category
  has_many :carts, dependent: :destroy
  has_many :orders, through: :carts
  scope :recent_foods, ->{order created_at: :desc}
  scope :search_by_name,
        ->(name){where "name LIKE ?", "%#{name}%" if name.present?}
  scope :find_foods_cart, ->(pr_id){where id: pr_id}
  scope :filter_category,
        ->(category_id){where(category_id: category_id) if category_id.present?}
  delegate :category_name, to: :category
  enum status: {disabled: 0, enabled: 1}
  has_one_attached :thumbnail
  has_many_attached :images
  accepts_nested_attributes_for :category, allow_destroy: true,
                                           reject_if: :validate_nested

  validates :category, presence: true

  validates :name, presence: true,
    length: {
      maximum: Settings.len_max
    }

  validates :price, presence: true,
                    numericality:
                    {
                      only_integer: false,
                      greater_than_or_equal_to: Settings.init_number
                    }

  validates :description, presence: true,
    length: {
      minimum: Settings.len_min,
      maximum: Settings.len_max_des
    }

  validates :quantity, presence: true,
                       numericality:
                       {
                         only_integer: true,
                         greater_than_or_equal_to: Settings.init_number
                       }

  validates :images,
            content_type:
            {
              in: Settings.image.format,
              message: I18n.t("validate_image.msg_format")
            },
            size:
            {
              less_than: Settings.image.size_1mb.megabytes,
              message: I18n.t("validate_image.msg_size")
            }

  def display_image image
    image.variant(resize: Settings.resize_images).processed
  end

  def display_thumbnail size = Settings.resize_thumbnail
    thumbnail.variant(resize: size).processed
  end

  def validate_nested attribute
    return true if attribute[:name].blank?
  end
end
