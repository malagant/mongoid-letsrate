MODELS = File.join(File.dirname(__FILE__), 'models')
$LOAD_PATH.unshift(MODELS)


require 'bundler/setup'

Bundler.setup

require 'bson'
require 'mongoid'
require 'active_support'
require 'action_view'
require 'mongoid-letsrate'

Mongoid.configure do |config|
  config.connect_to('mongoid-letsrate-test')
end

Dir[ File.join(MODELS, '*.rb') ].sort.each { |file| require File.basename(file) }

require 'mongoid-rspec'

RSpec.configure do |config|
  config.include RSpec::Matchers
  config.include Mongoid::Matchers
  config.mock_with :rspec
  config.after :all do
    Mongoid::Config.purge!
  end
end