class Rate
  include Mongoid::Document
  include Mongoid::Timestamps

  field :stars, type: Float

  belongs_to :rater, :class_name => '<%= file_name.classify %>'
  belongs_to :rateable, :polymorphic => true
end