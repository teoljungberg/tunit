# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tunit/version'

Gem::Specification.new do |spec|
  spec.name          = "tunit"
  spec.version       = Tunit::VERSION
  spec.authors       = ["Teo Ljungberg"]
  spec.email         = ["teo.ljungberg@gmail.com"]
  spec.summary       = %q{My take on a TDD testing framework}
  spec.description   = %q{It's basicly minitest}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
