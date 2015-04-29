# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'maintenance_mode/version'

Gem::Specification.new do |spec|
  spec.name          = 'maintenance_mode'
  if ENV['TRAVIS']
    spec.version       = "#{MaintenanceMode::VERSION}.alpha.#{ENV['TRAVIS_BUILD_NUMBER']}"
  else
    spec.version       = MaintenanceMode::VERSION
  end
  spec.authors       = ["Ryan Taylor Long"]
  spec.email         = ["ryan.long@goodguide.com"]
  spec.summary       = "This provides a simple interface to a 'maintenance mode' toggle with optional maintenance message."
  spec.homepage      = 'http://github.com/goodguide/maintenance_mode'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.1.0'

  all_files = `git ls-files -z`.split("\x0")
  spec.files         = all_files - all_files.grep(%r{^.travis.yml})
  spec.executables   = all_files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = all_files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.6.1'
end
