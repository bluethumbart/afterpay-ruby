# frozen_string_literal: true

module Afterpay
  class Refund
    attr_accessor :request_id, :amount, :merchant_reference, :refund_id, :refunded_at,
                  :refund_merchant_reference

    def initialize(attributes)
      @request_id = attributes[:requestId]
      @amount = attributes[:amount]
      @merchant_reference = attributes[:merchantReference]
      @refund_id = attributes[:refundId]
      @refunded_at = attributes[:refundAt]
      @refund_merchant_reference = attributes[:refundMerchantReference]
    end

    def self.execute(request_id:, order_id:, amount:, merchant_reference:,
                     refund_merchant_reference:)
      request = Afterpay.client.post("/v2/payments/#{order_id}/refund") do |req|
        req.body = {
          requestId: request_id,
          amount: Utils::Money.api_hash(amount),
          merchantReference: merchant_reference,
          refundMerchantReference: refund_merchant_reference
        }
      end
      new(request.body)
    end
  end
end
