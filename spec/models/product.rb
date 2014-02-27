class Product
  include Mongoid::Document
  include Mongoid::Letsrate

  letsrate_rateable
end
