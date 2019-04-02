require_relative "afterpay/version"
require_relative "afterpay/client"
require_relative "afterpay/config"
require_relative "afterpay/consumer"
require_relative "afterpay/item"
require_relative "afterpay/order"

module Afterpay
  class << self
    attr_accessor :config
  end

  def self.client
    Client.new
  end

  def self.configure
    self.config ||= Config.new
    yield(config) if block_given?
    config.fetch_remote_config.freeze
  end

  def self.env
    config.env
  end
end
