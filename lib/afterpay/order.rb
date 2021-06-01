# frozen_string_literal: true

require "pry"

module Afterpay
  # The Order object for creating an order to `/v2/checkouts`
  class Order
    attr_accessor :total, :consumer, :items, :shipping, :tax, :discounts,
                  :billing, :shipping_address, :billing_address, :reference,
                  :payment_type, :success_url, :cancel_url, :redirect_checkout_url

    attr_reader :expiry, :token, :error

    # Finds Order from Afterpay API
    # @param token [String]
    # @return [Order]
    def self.find(token)
      request = Afterpay.client.get("/v2/checkouts/#{token}")

      Order.from_response(request.body)
    end

    # Builds Order from response
    # @param response [Hash] response params from API
    # @return [Order]
    def self.from_response(response)
      return nil if response.nil?

      new(
        total: Utils::Money.from_response(response[:total]),
        consumer: Consumer.from_response(response[:consumer]),
        items: response[:items].map { |item| Item.from_response(item) },
        billing_address: Address.from_response(response[:billing]),
        shipping_address: Address.from_response(response[:shipping]),
        discounts: response[:discounts].map { |discount| Discount.from_response(discount) },
        tax: Utils::Money.from_response(response[:taxAmount]),
        shipping: Utils::Money.from_response(response[:shippingAmount])
      )
    end

    # Helper function to create an Order and calls #create
    #
    # @param (see #initialize)
    # @return [Order::Response] containing token, error, valid?
    def self.create(*args)
      new(*args).create
    end

    # Initializes an Order object
    #
    # @overload initialize(total:, items:, consumer:, success_url:, cancel_url:, payment_type:)
    #   @param total [Money] a Money object
    #   @param items [Array<Afterpay::Item>] receives items for order
    #   @param consumer [Afterpay::Consume] the consumer for the order
    #   @param success_url [String] the path to redirect on successful payment
    #   @param cancel_url [String] the path to redirect on failed payment
    #   @param payment_type [String] Payment type defaults to {Config#type}
    #   @param shipping [Money] optional the billing Address
    #   @param discounts [Array<Afterpay::Discount>] optional discounts
    #   @param billing_address [<Afterpay::Address>] optional the billing Address
    #   @param shipping_address [<Afterpay::Address>] optional the shipping Address
    def initialize(attributes = {})
      attributes.each { |key, value| instance_variable_set(:"@#{key}", value) }
      @apayment_type ||= Afterpay.config.type
      @token ||= nil
      @expiry ||= nil
      @error = nil
    end

    # rubocop:disable Metrics/CyclomaticComplexity

    # Builds structure to API specs
    def to_hash
      data = {
        amount: Utils::Money.api_hash(total),
        consumer: consumer.to_hash,
        items: items.map(&:to_hash),
        merchant: {
          redirectConfirmUrl: success_url,
          redirectCancelUrl: cancel_url
        },
        merchantReference: reference,
        taxAmount: tax,
        paymentType: payment_type
      }

      data[:taxAmount] = Utils::Money.api_hash(tax) if tax
      data[:shippingAmount] = Utils::Money.api_hash(shipping) if shipping
      data[:discounts] = discounts.map(&:to_hash) if discounts
      data[:billing] = billing_address.to_hash if billing_address
      data[:shipping] = shipping_address.to_hash if shipping_address
      data
    end

    # rubocop:enable Metrics/CyclomaticComplexity

    # Sends the create request to Afterpay server
    # @return [Response]
    def create
      request = Afterpay.client.post("/v2/checkouts") do |req|
        req.body = to_hash
      end
      response = request.body
      if request.success?
        @expiry = response[:expires]
        @token = response[:token]
        @redirect_checkout_url = response[:redirectCheckoutUrl]
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
