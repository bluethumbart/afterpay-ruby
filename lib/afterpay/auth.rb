# frozen_string_literal: true

module Afterpay
  class Auth
    attr_accessor :request_id, :token, :merchant_reference, :error

    def self.execute(request_id:, token:, merchant_reference:)
      request = Afterpay.client.post("/v2/payments/auth") do |req|
        req.body = {
          requestId: request_id,
          token: token,
          merchantReference: merchant_reference
        }
      end

      new(request.body)
    end

    def initialize(attributes)
      @request_id = attributes[:request_id]
      @token = attributes[:token]
      @merchant_reference = attributes[:merchant_reference]
      @error = Error.new(attributes) if attributes[:errorId]
    end

    def success?
      @status == "APPROVED"
    end
  end
end
