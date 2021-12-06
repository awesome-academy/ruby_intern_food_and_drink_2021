module FoodsHelper
  def gravatar_for product, options = {size: Settings.length.max_size}
    gravatar_id = Digest::MD5.hexdigest(product.name.downcase)
    size = options[:size]
    gravatar_url =
      "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: product.name, class: "gravatar")
  end

  def check_image?
    if @food.thumbnail.attached?
      image_tag(@food.display_thumbnail)
    else
      gravatar_for @food, size: Settings.medium_size
    end
  end

  def check_quantity? quantity
    quantity.zero?
  end
end
