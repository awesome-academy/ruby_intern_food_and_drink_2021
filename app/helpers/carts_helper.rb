module CartsHelper
  def check_thumbnail? thum
    if thum.thumbnail.present?
      image_tag thum.thumbnail.variant(resize_to_limit:
        [Settings.gravatar.medium_size, Settings.gravatar.medium_size])
    else
      gravatar_for thum, size: Settings.gravatar.medium_size
    end
  end
end
