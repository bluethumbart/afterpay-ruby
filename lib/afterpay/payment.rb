# frozen_string_literal: true

module Afterpay
  # They Payment object
  class Payment
    # Executes the Payment
    #
    # @param token [String] the Order token
    # @param reference [String] the reference for payment
    # @return [Payment] the Payment object
    def self.execute(token:, reference:)
      request = Afterpay.client.post("/v2/payments/capture") do |req|
        req.body = {
          token: token,
          merchantRefernce: reference
        }
      end

      new(request.body)
    end

    attr_accessor :id, :token, :status, :created, :original_amount, :open_to_capture_amount,
                  :payment_state, :merchant_reference, :refunds, :order, :events, :error

    # Initialize Payment from response
    def initialize(attributes)
      @id = attributes[:id]
      @status = attributes[:status]
      @created = attributes[:created]
      @original_amount = Utils::Money.from_response(attributes[:originalAmount])
      @open_to_capture_amount = Utils::Money.from_response(attributes[:openToCaptureAmount])
      @payment_state = attributes[:paymentState]
      @refunds = attributes[:refunds]
      @order = Order.from_response(attributes[:orderDetails])
      @events = attributes[:events]
      @error = Error.new(attributes) if attributes[:errorId]
    end

    def success?
      @status == "APPROVED"
    end
  end
end
