# frozen_string_literal: true

require File.expand_path("lib/ramverk/database/version", __dir__)

Gem::Specification.new do |spec|
  spec.name = "ramverk-database"
  spec.version = Ramverk::Database::VERSION
  spec.summary = "Database (Sequel) integration for Ramverk"

  spec.required_ruby_version = ">= 2.5.0"
  spec.required_rubygems_version = ">= 2.5.0"

  spec.license = "MIT"

  spec.author = "Tobias Sandelius"
  spec.email = "tobias@sandeli.us"
  spec.homepage = "https://github.com/ramverk/ramverk-database"

  spec.files = `git ls-files -z`.split("\x0")
  spec.test_files = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "ramverk", "~> 0.10"
  spec.add_runtime_dependency "sequel", "~> 5"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
