# -*- encoding : utf-8 -*-
class RatingCache
  include Mongoid::Document
  include Mongoid::Timestamps

  field :avg, type: Float
  field :qty, type: Integer

  belongs_to :cacheable, :polymorphic => true
end
