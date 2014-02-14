# -*- encoding : utf-8 -*-
require 'active_support/concern'

module Mongoid
  module Letsrate
    extend ActiveSupport::Concern

    def rate(stars, user, dirichlet_method=false)
      if can_rate? user
        rates.create! do |r|
          r.stars = stars
          r.rater = user
        end
        if dirichlet_method
          update_rate_average_dirichlet(stars)
        else
          update_rate_average(stars)
        end
      else
        raise 'User has already rated.'
      end
    end

    def update_rate_average_dirichlet(stars)
      ## assumes 5 possible vote categories
      dp = {1 => 1, 2 => 1, 3 => 1, 4 => 1, 5 => 1}
      stars_group = Hash[rates.group(:stars).count.map { |k, v| [k.to_i, v] }]
      posterior = dp.merge(stars_group) { |key, a, b| a + b }
      sum = posterior.map { |i, v| v }.inject { |a, b| a + b }
      davg = posterior.map { |i, v| i * v }.inject { |a, b| a + b }.to_f / sum

      if average.nil?
        RatingCache.create! do |avg|
          avg.cacheable_id = self.id
          avg.cacheable_type = self.class.name
          avg.qty = 1
          avg.avg = davg
        end
      else
        a = average
        a.qty = rates.count
        a.avg = davg
        a.save!(validate: false)
      end
    end

    def update_rate_average(stars)
      if average.nil?
        RatingCache.create! do |avg|
          avg.cacheable_id = self.id
          avg.cacheable_type = self.class.name
          avg.avg = stars
          avg.qty = 1
        end
      else
        a = average
        a.qty = rates.count
        a.avg = rates.average(:stars)
        a.save!(validate: false)
      end
    end

    def can_rate?(user)
      user.ratings_given.where(rateable_id: id, rateable_type: self.class.name).size.zero?
    end

    module ClassMethods

      def letsrate_rater
        has_many :ratings_given, :class_name => 'Rate'
        belongs_to :rater
      end

      def letsrate_rateable
        has_many :rates, :as => :rateable, :class_name => 'Rate', :dependent => :destroy
        has_many :raters

        has_one :average, :as => :cacheable,
                :class_name => 'RatingCache', :dependent => :destroy
      end
    end
  end
end

ActiveSupport.run_load_hooks(:mongoid_letsrate, Mongoid::Letsrate)
