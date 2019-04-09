# frozen_string_literal: true

module Afterpay
  # Money utility
  module MoneyUtil
    # Converts Afterpay response to `Money`
    # @return [Money]
    def self.from_response(response)
      return nil if response.nil?

      Money.from_amount(
        response[:amount].to_f,
        response[:currency]
      )
    end
  end
end
