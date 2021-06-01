# frozen_string_literal: true

module Afterpay
  class PaymentEvent
    attr_accessor :id, :created, :expires, :type, :amount, :payment_event_merchant_reference

    def initialize(attributes)
      @id = attributes[:id]
      @created = attributes[:created]
      @expires = attributes[:expires]
      @type = attributes[:expires]
      @amount = Utils::Money.from_response(attributes[:amount])
      @payment_event_merchant_reference = attributes[:paymentEventMerchantReference]
    end
  end
end
