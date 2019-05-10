require "vcr"
require "dotenv"

require "coveralls"
Coveralls.wear!

# require "simplecov"
#
# SimpleCov.start do
#   add_filter "/spec/"
# end

Dotenv.load

VCR.configure do |config|
  config.hook_into :faraday
  config.cassette_library_dir = "spec/vcr"

  config.allow_http_connections_when_no_cassette = true
  config.configure_rspec_metadata!
  config.filter_sensitive_data("<AUTH TOKEN>") { ENV["AUTH_TOKEN"] }
end

require "bundler/setup"
require "pry"
require "afterpay"

# Enables sandbox with SANDBOX=true to test sandbox and record VCR
require "./configure" if ENV["SANDBOX"]

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
