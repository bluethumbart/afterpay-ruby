require "bundler/setup"
require "afterpay"
require "webmock"
require "money"
SANDBOX_URL = "https://api-sandbox.afterpay.com".freeze

RSpec.configure do |config|
  include WebMock::API

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
