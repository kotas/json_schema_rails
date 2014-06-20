# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rspec/rails"

Rails.backtrace_cleaner.remove_silencers!

TEST_SCHEMAS_DIR = File.expand_path("../fixtures/schemas", __FILE__)
TEST_HYPER_SCHEMA_FILE = File.expand_path("../fixtures/hyper_schema.yml", __FILE__)

RSpec.configure do |config|
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.infer_spec_type_from_file_location!
end
