# frozen_string_literal: true

require "money"
require_relative "afterpay/utils/money"

require_relative "afterpay/version"
require_relative "afterpay/client"
require_relative "afterpay/config"
require_relative "afterpay/consumer"
require_relative "afterpay/item"
require_relative "afterpay/order"
require_relative "afterpay/payment"
require_relative "afterpay/error"
require_relative "afterpay/discount"
require_relative "afterpay/address"
require_relative "afterpay/refund"
require_relative "afterpay/shipping_courier"
require_relative "afterpay/payment_event"

module Afterpay
  class << self
    attr_accessor :config
  end

  # Helper function for Afterpay::Client
  # Use Afterpay.client to send receive request
  def self.client
    Client.new
  end

  # Configure block to setup configuration
  #
  #  Afterpay.configure do |conf|
  #    conf.app_id = <app_id>
  #    conf.secret = <secret>
  #  end
  #
  def self.configure
    self.config ||= Config.new
    yield(config) if block_given?
    config.fetch_remote_config unless config.skip_remote_config
    config
  end

  def self.env
    config.env
  end
end
