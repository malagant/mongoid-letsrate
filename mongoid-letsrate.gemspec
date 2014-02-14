# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'mongoid_letsrate/version'

Gem::Specification.new do |s|
  s.name        = 'mongoid-letsrate'
  s.version     = MongoidLetsrate::VERSION
  s.authors     = ['Michael Johann','Murat GUZEL']
  s.email       = ['mjohann@rails-experts.com']
  s.homepage    = 'http://github.com/malagant/mongoid-letsrate'
  s.summary     = %q{Provides the best solution to add rating functionality to your models using mongoid.}
  s.description = %q{Provides the best solution to add rating functionality to your models using mongoid.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
