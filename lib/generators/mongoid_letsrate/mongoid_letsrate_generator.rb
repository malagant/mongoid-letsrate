# -*- encoding : utf-8 -*-
class MongoidLetsrateGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  desc 'copying jquery.raty files to assets directory ...'
  def copying
    copy_file 'jquery.raty.js', 'app/assets/javascripts/jquery.raty.js'
    copy_file 'star-on.png', 'app/assets/images/star-on.png'
    copy_file 'star-off.png', 'app/assets/images/star-off.png'
    copy_file 'star-half.png', 'app/assets/images/star-half.png'
    copy_file 'letsrate.js.erb', 'app/assets/javascripts/letsrate.js.erb'
  end

  desc 'model is being created...'
  def create_model
    model_file = File.join('app/models', "#{file_path}.rb")
    raise "User model (#{model_file}) must exits." unless File.exists?(model_file)
    class_collisions 'Rate'
    template 'model.rb', File.join('app/models', 'rate.rb')
    template 'cache_model.rb', File.join('app/models', 'rating_cache.rb')
    template 'rater_controller.rb', File.join('app/controllers', 'rater_controller.rb')
  end

  def add_rate_path_to_route
    route "post '/rate' => 'rater#create', :as => 'rate'"
  end
end
