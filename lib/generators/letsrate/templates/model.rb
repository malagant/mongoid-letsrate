class Rate
  include Monogoid::Document
  belongs_to :rater, :class_name => '<%= file_name.classify %>'
  belongs_to :rateable, :polymorphic => true
end