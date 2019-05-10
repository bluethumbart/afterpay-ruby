# frozen_string_literal: true

module Afterpay
  class Discount
    attr_accessor :name, :amount

    def initialize(name:, amount:)
      @name = name
      @amount = amount
    end

    def to_hash
      {
        displayName: name,
        amount: {
          amount: amount.to_f,
          currency: amount.currency.iso_code
        }
      }
    end
  end
end
