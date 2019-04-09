# frozen_string_literal: true

require "dotenv"
Dotenv.load

Afterpay.configure do |config|
  config.app_id = ENV["APP_ID"]
  config.secret = ENV["SECRET"]

  # Sets to raise errors when 404
  # config.raise_errors = true

  # Sets the environment for Afterpay
  # config.env = "sandbox" # :live
end
