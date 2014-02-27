class User
  include Mongoid::Document
  include Mongoid::Letsrate

  letsrate_rater
end