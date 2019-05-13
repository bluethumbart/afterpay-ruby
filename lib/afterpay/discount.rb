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
        amount: Utils::Money.api_hash(amount)
      }
    end

    def self.from_response(response)
      return nil if response.nil?

      new(
        name: response[:display_name],
        amount: Utils::Money.from_response(response[:amount])
      )
    end
  end
end
