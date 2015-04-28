# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'maintenance_mode/version'

Gem::Specification.new do |spec|
  spec.name          = "maintenance_mode"
  spec.version       = MaintenanceMode::VERSION
  spec.authors       = ["Ryan Taylor Long"]
  spec.email         = ["ryan.long@goodguide.com"]
  spec.summary       = "This provides a simple interface to a 'maintenance mode' toggle with optional maintenance message."
  spec.homepage      = "http://github.com/goodguide/maintenance_mode"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
