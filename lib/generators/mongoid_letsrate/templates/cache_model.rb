class RatingCache
  include Mongoid::Document
  include Mongoid::Timestamps

  field :avg, type: Float, null: false
  field :qty, type: Integer, null: false
  field :dimension, type: String

  belongs_to :cacheable, :polymorphic => true
end