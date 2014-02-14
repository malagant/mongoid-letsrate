module Helpers
  def rating_for(rateable_obj, options={})

    cached_average = rateable_obj.average

    avg = cached_average ? cached_average.avg : 0

    star = options[:star] || 5

    disable_after_rate = options[:disable_after_rate] || true

    readonly = !(current_user && rateable_obj.can_rate?(current_user))

    content_tag :div, '', :class => "star", "data-rating" => avg,
                "data-id" => rateable_obj.id, "data-classname" => rateable_obj.class.name,
                "data-disable-after-rate" => disable_after_rate,
                "data-readonly" => readonly,
                "data-star-count" => star
  end

  def rating_for_user(rateable_obj, rating_user, options = {})
    @object = rateable_obj
    @user = rating_user
    @rating = Rate.find_by_rater_id_and_rateable_id(@user.id, @object.id)
    stars = @rating ? @rating.stars : 0

    disable_after_rate = options[:disable_after_rate] || false

    readonly=false
    if disable_after_rate
      readonly = current_user.present? ? !rateable_obj.can_rate?(current_user.id) : true
    end

    content_tag :div, '', :class => "star", "data-rating" => stars,
                "data-id" => rateable_obj.id, "data-classname" => rateable_obj.class.name,
                "data-disable-after-rate" => disable_after_rate,
                "data-readonly" => readonly,
                "data-star-count" => stars
  end
end

class ActionView::Base
  include Helpers
end
