# frozen_string_literal: true

require "ostruct"
require "forwardable"
require_relative "money_utils"

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
    # @params response [Hash] response params from API
    # @return [Order]
    def self.from_response(response)
      new(
        total: Money.from_amount(
          response.dig("total", "amount").to_f,
          response.dig("total", "currency")
        ),
        consumer: Consumer.from_response(response["consumer"]),
        items: response["items"].map { |item| Item.from_response(item) },
        # billing: response["billing"],
        # shipping: response["shipping"],
        # discounts: Discount.from_response(response["discounts"]),
        tax: MoneyUtils.from_response(response["taxAmount"]),
        shipping: MoneyUtils.from_response(response["shippingAmount"])
      )
    end

    # Helper function to create an Order and calls #create
    #
    # @param (see #initialize)
    # @return [Order::Response] containing token, error, valid?
    def self.create(*args)
      new(*args).create
    end

    attr_reader :attributes

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
    end

    # Builds structure to API specs
    def to_hash
      {
        totalAmount: {
          amount: total.to_f,
          currency: total.currency
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
    end

    # Sends the create request to Afterpay server
    # @return [Response]
    def create
      request = Afterpay.client.post("/v1/orders") do |req|
        req.body = to_hash
      end

      Response.new(request.body)
    end

    # The response object returned after create
    class Response
      attr_accessor :token, :expiry, :error

      def initialize(response)
        @token = response["token"]
        @expiry = Time.zone.parse(response["expires"]) if response["expires"]
        @error = Error.new(response) if response["errorCode"]
      end

      def success?
        error.nil?
      end

      # Error class with accessor to methods
      class Error
        attr_accessor :code, :id, :message

        def initialize(response)
          @id = response["errorId"]
          @code = response["errorCode"]
          @message = response["message"]
        end
      end
    end
  end
end
