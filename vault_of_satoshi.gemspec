# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vault_of_satoshi/version'

Gem::Specification.new do |spec|
  spec.name          = "vault_of_satoshi"
  spec.version       = VaultOfSatoshi::VERSION
  spec.author        = "Frank Bonetti"
  spec.email         = "frank.r.bonetti@gmail.com"
  spec.description   = "A Ruby wrapper for the Vault of Satoshi API"
  spec.summary       = "A Ruby wrapper for the Vault of Satoshi API"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3.5"
  spec.add_development_dependency "rake", "~> 1.3.5"
  spec.add_development_dependency 'httparty', "~> 0.13.0"
  spec.add_development_dependency 'active_support', "~> 3.0.0"
end
