# frozen_string_literal: true

module Afterpay
  class Refund
    attr_accessor :request_id, :amount, :merchant_reference, :refund_id, :refunded_at,
                   :refund_merchant_reference

    def initialize(request_id:, amount:)
      @request_id = request_id
      @amount = amount
      @merchant_reference = merchant_reference
      @refund_id = refund_id
      @refunded_at = refunded_at
      @refund_merchant_reference = refund_merchant_reference
    end
  end
end
