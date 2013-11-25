# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fhir/version'

Gem::Specification.new do |spec|
  spec.name          = "fhir"
  spec.version       = Fhir::VERSION
  spec.authors       = ["niquola"]
  spec.email         = ["niquola@gmail.com"]
  spec.description   = %q{FHIR object model}
  spec.summary       = %q{FHIR object model}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'virtus'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'activemodel'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
