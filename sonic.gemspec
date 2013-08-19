# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sonic/version'

Gem::Specification.new do |spec|
  spec.name          = "sonic"
  spec.version       = Sonic::VERSION
  spec.authors       = ["Michael Bulat"]
  spec.email         = ["mbulat@crazydogsoftware.com"]
  spec.description   = %q{Sonic is a Rails engine which provides a status page for your applications
                          services, along with a number of tools to periodically check those services.}
  spec.summary       = %q{Sonic is a Rails Engine status page and services checker.}
  spec.homepage      = "http://github.com/sonic"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~> 3.1"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-rails", "~> 2.6"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "fuubar"
end
