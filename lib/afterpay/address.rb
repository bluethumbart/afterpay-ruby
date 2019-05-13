# frozen_string_literal: true

module Afterpay
  class Address
    attr_accessor :name, :line_1, :line_2, :suburb, :state, :postcode, :country, :phone

    # Initializes an Order object
    #
    # @overload initialize(total:, items:, consumer:, success_url:, cancel_url:, payment_type:)
    #   @param name [String] The name
    #   @param line_1 [String] Address line 1
    #   @param line_2 [String] optional Address line 2
    #   @param suburb [String] optional Suburb
    #   @param state [String] State
    #   @param postcode [String] Postal code
    #   @param country [String] optional country Code
    #   @param phone [String|Number] The phone number
    def initialize(attributes = {})
      @name = attributes[:name]
      @line_1 = attributes[:line_1] || ""
      @line_2 = attributes[:line_2] || ""
      @suburb = attributes[:suburb] || ""
      @state = attributes[:state] || ""
      @postcode = attributes[:postcode]
      @country = attributes[:country] || "AU"
      @phone = attributes[:phone]
    end

    def to_hash
      {
        name: name,
        line1: line_1,
        line2: line_2,
        suburb: suburb,
        state: state,
        postcode: postcode.to_s,
        countryCode: country,
        phoneNumber: phone.to_s
      }
    end

    def self.from_response(response)
      return nil if response.nil?

      new(
        name: response[:name],
        line_1: response[:line1],
        line_2: response[:line2],
        suburb: response[:suburb],
        state: response[:state],
        postcode: response[:postcode],
        country: response[:countryCode],
        phone: response[:phoneNumber]
      )
    end
  end
end
