# frozen_string_literal: true

module Afterpay
  class ShippingCourier
    attr_accessor :shipped_at, :name, :tracking, :priority

    def initialize(shipped_at:, name:, tracking:, priority:)
      @shipped_at = shipped_at
      @name = name
      @tracking = tracking
      @priority = priority
    end
  end
end
