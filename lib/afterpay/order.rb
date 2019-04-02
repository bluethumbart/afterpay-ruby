module Afterpay
  class Order
    def self.create(*args)
      body = Afterpay.client.post("/v1/orders") do |req|
        req.body = new(*args).to_hash
      end.body

      Response.new(body)
    end

    def initialize(total:, items:, consumer:, success_url:, cancel_url:, payment_type: nil)
      @total = total
      @consumer = consumer
      @items = items
      @success_url = success_url
      @cancel_url = cancel_url
      @payment_type = payment_type
    end

    def to_hash
      {
        totalAmount: {
          amount: @total.to_f,
          currency: @total.currency
        },
        consumer: @consumer.to_hash,
        items: @items.map(&:to_hash),
        merchant: {
          redirectConfirmUrl: @success_url,
          redirectCancelUrl: @cancel_url
        },
        paymentType: @payment_type || Afterpay.config.type
      }
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
