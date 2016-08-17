# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'software_challenge_client/version'

Gem::Specification.new do |spec|
  spec.name          = "software_challenge_client"
  spec.version       = SoftwareChallengeClient::VERSION
  spec.authors       = ["Ralf-Tobias Diekert"]
  spec.email         = ["rtd@informatik.uni-kiel.de"]

  spec.summary       = %q{This gem provides functions to build a client for the coding competition Software-Challenge 2016.}
  spec.description   = %q{}
  spec.homepage      = "http://www.software-challenge.de"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.10"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "yard", ">= 0.8"
end