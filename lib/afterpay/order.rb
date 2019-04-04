require "ostruct"

module Afterpay
  # The Order object for creating an order to `/v1/orders`
  class Order
    # Helper function to create an Order and calls #create
    #
    # returns Order::Response containing token, error, valid?
    def self.create(*args)
      new(*args).create
    end

    attr_reader :attr

    # Initializes an Order object
    #
    # total :: a Money object
    # items :: receives multiple [Afterpay::Items]
    # consumer :: receives Afterpay::Consumer
    # success_url :: the path to rederect on successful payment
    # cancel_url :: the path to rederect on failed payment
    # payment_type :: Payment type set by Afterpay
    def initialize(attributes = {})
      @attributes = OpenStruct.new(attributes)
      @attributes.payment_type ||= Afterpay.config.type
    end

    def to_hash
      {
        totalAmount: {
          amount: attributes.total.to_f,
          currency: attributes.total.currency
        },
        consumer: attributes.consumer.to_hash,
        items: attributes.items.map(&:to_hash),
        merchant: {
          redirectConfirmUrl: attributes.success_url,
          redirectCancelUrl: attributes.cancel_url
        },
        paymentType: attributes.payment_type
      }
    end

    # Sends the create request to Afterpay server
    def create
      body = Afterpay.client.post("/v1/orders") do |req|
        req.body = to_hash
      end.body

      Response.new(body)
    end

    class Response
      attr_accessor :token, :expiry, :error

      def initialize(response)
        @token = response["token"]
        @expiry = Time.zone.parse(response["expires"]) if response["expires"]
        @error = Error.new(response) if response["errorCode"]
      end

      def valid?
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

=begin
Afterpay::Order.create(
  total: Money.from_amount(19000000),
  items: [Afterpay::Item.new(name: Listing.displayable.last.title, sku: 1234, price: Money.from_amount(10000))],
  consumer: Afterpay::Consumer.new(first_name: "AA", last_name: "BB", phone: 123123, email: "johndoe@gmail.com"),
  success_url: "https://bluethumb.com.au?success=tru",
  cancel_url: "https://bluethumb.com.au?error=fail"
)
=end
