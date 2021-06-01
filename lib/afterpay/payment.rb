# frozen_string_literal: true

module Afterpay
  # They Payment object
  class Payment
    attr_accessor :id, :token, :status, :created, :original_amount, :open_to_capture_amount,
                  :payment_state, :merchant_reference, :refunds, :order, :events, :error

    # Initialize Payment from response
    def initialize(attributes)
      @id = attributes[:id]
      @token = attributes[:token]
      @status = attributes[:status]
      @created = attributes[:created]
      @original_amount = Utils::Money.from_response(attributes[:originalAmount])
      @open_to_capture_amount = Utils::Money.from_response(attributes[:openToCaptureAmount])
      @payment_state = attributes[:paymentState]
      @merchant_reference = attributes[:merchantReference]
      @refunds = attributes[:refunds]
      @order = Order.from_response(attributes[:orderDetails])
      @events = attributes[:events]
      @error = Error.new(attributes) if attributes[:errorId]
    end

    def success?
      @status == "APPROVED"
    end

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

    def self.execute_auth(request_id:, token:, merchant_reference:)
      request = Afterpay.client.post("/v2/payments/auth") do |req|
        req.body = {
          requestId: request_id,
          token: token,
          merchantReference: merchant_reference
        }
      end
      new(request.body)
    end

    def self.execute_deffered_payment(request_id:, reference:, amount:,
                                      payment_event_merchant_reference:, order_id:)
      request = Afterpay.client.post("/v2/payments/#{order_id}/capture") do |req|
        req.body = {
          requestId: request_id,
          merchantRefernce: reference,
          amount: Utils::Money.api_hash(amount),
          paymentEventMerchantReference: payment_event_merchant_reference
        }
      end
      new(request.body)
    end

    def self.execute_void(request_id:, order_id:, amount:)
      request = Afterpay.client.post("/v2/payments/#{order_id}/void") do |req|
        req.body = {
          requestId: request_id,
          amount: Utils::Money.api_hash(amount)
        }
      end
      new(request.body)
    end
  end
end
