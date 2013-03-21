# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'globalize3/validations/version'

Gem::Specification.new do |spec|
  spec.name          = "globalize3-validations"
  spec.version       = Globalize3::Validations::VERSION
  spec.authors       = ["Maximilian Herold"]
  spec.email         = ["herold@emjot.de"]
  spec.description   = %q{adds a uniqueness validator for globalize3 translated models}
  spec.summary       = %q{uniqueness validation for globalize3 translated models}
  spec.homepage      = "https://github.com/emjot/globalize3-validations"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rails", "~> 3.0"
  spec.add_runtime_dependency "globalize3", "~> 0.3"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "appraisal", "~> 0.5.1"
  spec.add_development_dependency "rspec-rails", "~> 2.8.0"
  spec.add_development_dependency "database_cleaner", "~> 0.6"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rake"
end
