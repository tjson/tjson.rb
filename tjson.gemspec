# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tjson/version"

Gem::Specification.new do |spec|
  spec.name        = "tjson"
  spec.version     = TJSON::VERSION
  spec.authors     = ["Tony Arcieri"]
  spec.email       = ["bascule@gmail.com"]
  spec.licenses    = ["MIT"]
  spec.homepage    = "https://github.com/tjson/tjson-ruby"
  spec.summary     = "Tagged JSON with Rich Types"
  spec.description = "A JSON-compatible serialization format with rich type annotations"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.0"

  spec.add_runtime_dependency "base32", ">= 0.3"

  spec.add_development_dependency "bundler", "~> 1.13"
end
