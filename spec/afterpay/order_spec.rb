require "spec_helper"

RSpec.describe Afterpay::Order do
  let(:discount) do
    Afterpay::Discount.new(
      name: "Coupon",
      amount: Money.from_amount(1000, "AUD")
    )
  end

  # Unused as API does not seem to accept address.
  let(:address) do
    Afterpay::Address.new(
      name: "John Doe",
      line_1: "An address",
      suburb: "Melbourne",
      state: "QLD",
      postcode: 3000,
      phone: 0400000000,
    )
  end

  subject(:order) do
    described_class.new(
      total: Money.from_amount(1000, "AUD"),
      consumer: Afterpay::Consumer.new(
        email: "johndoe@mail.com",
        phone: 12345678910,
        first_name: "FName",
        last_name: "LName"
      ),
      items: [Afterpay::Item.new(
        name: "Item Name",
        sku: 1,
        price: Money.from_amount(1000, "AUD")
      )],
      success_url: "http://example.com/success",
      cancel_url: "http://example.com/cancel"
    )
  end

  describe "#create" do
    it "returns a valid Order", :vcr do
      pp order.to_hash
      order.create

      expect(order.success?).to be true
      expect(order.token).to eq(order.token)
    end

    it "creates with error", :vcr do
      order.attributes.success_url = ""
      order.create

      expect(order.success?).to be false
      expect(order.error).not_to be_nil
    end

    context "with discounts", :vcr do
      it "returns valid Order" do
        order.attributes.discounts = [discount]
        order.create

        expect(order.success?).to be true
        expect(order.token).to eq(order.token)
      end
    end
  end

  describe "#to_hash" do
    it "transform Order to Afterpay hash" do
      hash = order.to_hash

      expect(hash[:totalAmount][:amount]).to eq(1000.0)
      expect(hash[:totalAmount][:currency]).to eq("AUD")
      expect(hash[:consumer]).to be_a Hash
      expect(hash[:items]).not_to be_empty
      expect(hash[:merchant][:redirectConfirmUrl]).to match(/success/)
      expect(hash[:merchant][:redirectCancelUrl]).to match(/cancel/)
    end

    context "with optional discounts" do
      it "includes discounts in Order" do
        order.attributes.discounts = [discount]
        hash = order.to_hash

        expect(order.discounts.sample).to be_a(Afterpay::Discount)
        expect(hash[:discounts]).not_to be_empty
      end
    end
  end

  describe "#find" do
    let(:token) { "le4bavv8rl6m0m3d2rq7k5dvpvmoeetrhro64m0ihoj7ou8idmtv" }

    it "fetches order from server", :vcr do
      fetched_order = described_class.find(token)

      expect(fetched_order).to be_a Afterpay::Order
      expect(fetched_order.consumer.email).to eq(order.consumer.email)
      expect(fetched_order.token).to eq(order.token)
    end
  end
end
