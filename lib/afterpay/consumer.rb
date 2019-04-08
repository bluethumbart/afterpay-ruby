# frozen_string_literal: true

module Afterpay
  class Consumer
    attr_accessor :email, :phone, :first_name, :last_name

    def initialize(email:, phone:, first_name:, last_name:)
      @email = email
      @phone = phone
      @first_name = first_name
      @last_name = last_name
    end

    def to_hash
      {
        phoneNumber: phone,
        givenNames: first_name,
        surname: last_name,
        email: email
      }
    end

    # Builds Consumer from response
    def self.from_response(response)
      new(
        email: response["email"],
        first_name: response["givenNames"],
        last_name: response["surname"],
        phone: response["phoneNumber"]
      )
    end
  end
end
