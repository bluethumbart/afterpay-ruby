# frozen_string_literal: true

module Afterpay
  # The Refund object
  class Refund
    attr_reader :refund_id, :refunded_at, :error, :amount, :merchant_reference
    # == Refunds the Payment
    # @param order_id [String] unique order id returned by afterpay when capturing payment
    # @param reference [String] the reference for order at merchant end
    # @param payment_id [String] unique Payment id at merchant end
    # @param amount [Money] amount to be refunded
    # @return [Refund] the Refund object

    # == Response [Refund] Object
    # refund_id [String] unique ID returned by afterpay after successful refund
    # refunded_at [Timestamp] The timestamp at which the refund was done
    # error [Hash] error information if refund fails
    # amount [Money] amount refunded
    # merchant_reference [String] the reference for order at merchant end
    def self.execute(order_id:, reference:, payment_id:, amount:)
      request = Afterpay.client.post("/v1/payments/#{ order_id }/refund") do |req|
        req.body = {
          requestId: payment_id,
          merchantReference: reference,
          amount: Utils::Money.api_hash(amount)
        }
      end

      new(request.body)
    end

    # Initialize Refund from response
    def initialize(attributes)
      @refund_id = attributes[:refundId]
      @refunded_at = Time.parse(attributes[:refundedAt]) if attributes[:refundedAt].present?
      @amount = Utils::Money.from_response(attributes[:amount]) if attributes[:amount].present?
      @merchant_reference = attributes[:merchantReference]
      @error = Error.new(attributes) if attributes[:errorId]
    end

    def success?
      @refund_id.present?
    end
  end
end
