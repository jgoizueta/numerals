# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'numerals/version'

Gem::Specification.new do |spec|
  spec.name          = "numerals"
  spec.version       = Numerals::VERSION
  spec.authors       = ["Javier Goizueta"]
  spec.email         = ["jgoizueta@gmail.com"]
  spec.summary       = %q{Number representation as text.}
  spec.description   = %q{Number formatting and reading.}
  spec.homepage      = "https://github.com/jgoizueta/numerals"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'flt', "~> 1.4.3"
  spec.add_dependency 'modalsupport', "~> 0.9.2"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
