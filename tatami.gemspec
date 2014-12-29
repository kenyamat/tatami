# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tatami/version'

Gem::Specification.new do |spec|
  spec.name          = "tatami"
  spec.version       = Tatami::VERSION
  spec.authors       = ["Kenya Matsumoto"]
  spec.email         = ["kenyamat@hotmail.co.jp"]
  spec.summary       = %q{A ruby gem for web application testing.}
  spec.description   = %q{A ruby gem for web application testing.}
  spec.homepage      = "https://github.com/kenyamat/tatami"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'nokogiri', '~> 1.6'
  spec.add_development_dependency 'builder'
  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'httpclient', '~> 2.5'
  spec.add_development_dependency 'csv_parser', '~> 0.0.1'
end