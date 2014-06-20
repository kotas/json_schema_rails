$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "json_schema_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "json_schema_rails"
  s.version     = JsonSchemaRails::VERSION
  s.authors     = ["Kota Saito"]
  s.email       = ["kotas@kotas.jp"]
  s.homepage    = "https://github.com/kotas/json_schema_rails"
  s.summary     = "JSON schema validation for Rails"
  s.license     = "MIT"

  s.files       = `git ls-files`.split($\)
  s.test_files  = s.files.grep(%r{^(test|spec|features)/})

  s.add_runtime_dependency "activesupport", [">= 3.0", "< 4.2"]
  s.add_runtime_dependency "actionpack",    [">= 3.0", "< 4.2"]
  s.add_runtime_dependency "railties",      [">= 3.0", "< 4.2"]
  s.add_runtime_dependency "json_schema",   "~> 0.1.4"

  s.add_development_dependency "rails",     [">= 3.0", "< 4.2"]
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "guard-rspec"
end
