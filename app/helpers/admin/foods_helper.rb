module Admin::FoodsHelper
  def gravatar_for food, options = {size: Settings.gravatar.medium_size}
    gravatar_id = Digest::MD5.hexdigest(food.name.downcase)
    size = options[:size]
    gravatar_url =
      "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: food.name, class: "gravatar")
  end
end
