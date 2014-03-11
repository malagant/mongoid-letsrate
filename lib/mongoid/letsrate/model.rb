# -*- encoding : utf-8 -*-
require 'active_support/concern'

module Mongoid
  module Letsrate
    extend ActiveSupport::Concern

    def rate(stars, user)
      if can_rate? user
        rates.create! do |r|
          r.stars = stars
          r.rater = user
        end
        update_rate_average(stars)
      else
        raise 'User has already rated.'
      end
    end

    # The average rating
    def rating
      average ? average.avg : 0
    end

    def update_rate_average(stars)
      if average.nil?
        RatingCache.create! do |avg|
          puts "About to create average"
          avg.cacheable_id = self.id
          avg.cacheable_type = self.class.name
          avg.avg = stars
          avg.qty = 1
        end
      else
        puts "Found average"
        a = average
        all_stars = rates.map &:stars
        a.avg = all_stars.inject { |sum, value| sum + value } / all_stars.size
        a.qty = rates.count
        a.save!(validate: false)
      end
    end

    def can_rate?(user)
      user.ratings_given.where(rateable_id: id, rateable_type: self.class.name).size.zero?
    end

    module ClassMethods

      def letsrate_rater
        has_many :ratings_given, :class_name => 'Rate'
        belongs_to :rateable
      end

      def letsrate_rateable
        has_many :rates, :as => :rateable, :class_name => 'Rate', :dependent => :destroy
        has_many :raters, class_name: 'User'

        has_one :average, :as => :cacheable,
                :class_name => 'RatingCache', :dependent => :destroy
      end
    end
  end
end

ActiveSupport.run_load_hooks(:mongoid_letsrate, Mongoid::Letsrate)
