# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "cucumber-helpers"
  spec.version       =  ::FILE.read("VERSION")
  spec.authors       = ["Greg Beech","JP Hastings-Spital"]
  spec.email         = ["greg@blinkbox.com","jphastings@blinkbox.com"]
  spec.description   = %q{Helpers for step definitions in cucumber.}
  spec.summary       = %q{Helpers for cucumber.}
  spec.homepage      = "https://blinkboxbooks.github.io/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
