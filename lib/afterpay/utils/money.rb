# frozen_string_literal: true

module Afterpay
  module Utils
    class Money
      # Converts Afterpay response to `Money`
      # @return [Money]
      def self.from_response(response)
        return nil if response.nil?

        ::Money.from_amount(
          response[:amount].to_f,
          response[:currency]
        )
      end

      # Converts <oney to API compatible hash format
      def self.api_hash(money)
        {
          amount: money.dollars.to_f,
          currency: money.currency.iso_code
        }
      end
    end
  end
end
