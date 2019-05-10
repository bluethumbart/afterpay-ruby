# frozen_string_literal: true

require "ostruct"
require "forwardable"

module Afterpay
  # The Order object for creating an order to `/v1/orders`
  class Order
    extend Forwardable

    def_delegators :@attributes,
                   :total,
                   :consumer,
                   :items,
                   :shipping,
                   :tax,
                   :discounts,
                   :billing,
                   :shipping,
                   :merchant_reference

    # Finds Order from Afterpay API
    # @param token [String]
    # @return [Order]
    def self.find(token)
      request = Afterpay.client.get("/v1/orders/#{token}")

      Order.from_response(request.body)
    end

    # Builds Order from response
    # @param response [Hash] response params from API
    # @return [Order]
    def self.from_response(response)
      return nil if response.nil?

      new(
        total: MoneyUtil.from_response(response[:total]),
        consumer: Consumer.from_response(response[:consumer]),
        items: response[:items].map { |item| Item.from_response(item) },
        # billing: response[:billing],
        # shipping: response[:shipping],
        # discounts: Discount.from_response(response[:discounts]),
        tax: MoneyUtil.from_response(response[:taxAmount]),
        shipping: MoneyUtil.from_response(response[:shippingAmount])
      )
    end

    # Helper function to create an Order and calls #create
    #
    # @param (see #initialize)
    # @return [Order::Response] containing token, error, valid?
    def self.create(*args)
      new(*args).create
    end

    attr_reader :attributes, :expiry, :token, :error

    # Initializes an Order object
    #
    # @overload initialize(total:, items:, consumer:, success_url:, cancel_url:, payment_type:)
    #   @param total [Money] a Money object
    #   @param items [Array<Afterpay::Item>] receives items for order
    #   @param consumer [Afterpay::Consume] the consumer for the order
    #   @param success_url [String] the path to redirect on successful payment
    #   @param cancel_url [String] the path to redirect on failed payment
    #   @param payment_type [String] Payment type defaults to {Config#type}
    def initialize(attributes = {})
      @attributes = OpenStruct.new(attributes)
      @attributes.payment_type ||= Afterpay.config.type
      @token = @attributes.token || nil
      @expiry = nil
      @error = nil
    end

    # Builds structure to API specs
    def to_hash
      data = {
        totalAmount: {
          amount: total.to_f,
          currency: total.currency.iso_code
        },
        consumer: consumer.to_hash,
        items: items.map(&:to_hash),
        merchant: {
          redirectConfirmUrl: attributes.success_url,
          redirectCancelUrl: attributes.cancel_url
        },
        merchantReference: attributes.merchant_reference,
        taxAmount: attributes.tax,
        shippingAmount: attributes.shipping,
        paymentType: attributes.payment_type
      }

      if attributes.discounts
        data[:discounts] = attributes.discounts.map(&:to_hash)
      end

      data
    end

    # Sends the create request to Afterpay server
    # @return [Response]
    def create
      request = Afterpay.client.post("/v1/orders") do |req|
        req.body = to_hash
      end
      response = request.body

      if request.success?
        @expiry = Time.parse(response[:expires])
        @token = response[:token]
      else
        @error = Error.new(response)
      end
      self
    end

    def success?
      !@token.nil?
    end
  end
end
