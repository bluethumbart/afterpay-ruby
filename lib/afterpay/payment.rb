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
      request = Afterpay.client.post("/v1/payments/capture") do |req|
        req.body = {
          token: token,
          merchantRefernce: reference
        }
      end

      new(request.body)
    end

    attr_accessor :id, :status, :created, :total, :order

    def initialize(attributes)
      @id = attributes["id"]
      @status = attributes["status"]
      @created = attributes["created"]
      @total = Money.from_amount(
        attributes["amount"].to_f,
        attributes["currency"]
      )
      @order = Order.from_response(attributes["orderDetails"])
    end

    def success?
      @status == "APPROVED"
    end
  end
end
