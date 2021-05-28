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
      request.body
    end
  end
end
