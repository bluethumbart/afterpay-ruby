# frozen_string_literal: true

module Afterpay
  class Address
    attr_accessor :name, :line_1, :line_2, :area_1, :area_2, :region, :postcode, :country, :phone

    def initialize(attributes = {})
      @name = attributes[:name]
      @line_1 = attributes[:line_1] || ""
      @line_2 = attributes[:line_2] || ""
      @area_1 = attributes[:area_1] || ""
      @area_2 = attributes[:area_2] || ""
      @region = attributes[:region] || ""
      @postcode = attributes[:postcode]
      @country = attributes[:country] || "AU"
      @phone = attributes[:phone]
    end

    def to_hash
      {
        name: name,
        line1: line_1,
        line2: line_2,
        area_1: area_1,
        area_2: area_2,
        region: region,
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
        area_1: response[:area1],
        area_2: response[:area2],
        region: response[:region],
        postcode: response[:postcode],
        country: response[:countryCode],
        phone: response[:phoneNumber]
      )
    end
  end
end
