# frozen_string_literal: true

require "dotenv"
Dotenv.load

Money.default_currency = ENV["DEFAULT_CURRENCY"] || "AUD"

Afterpay.configure do |config|
  config.app_id = ENV["APP_ID"]
  config.secret = ENV["SECRET"]

  # Sets to raise errors when 404
  # config.raise_errors = true

  # Sets the environment for Afterpay
  # config.env = "sandbox" # :live
end

Afterpay.config.freeze
