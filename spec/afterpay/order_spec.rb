require "spec_helper"

RSpec.describe Afterpay::Order do
  let(:consumer) do
    Afterpay::Consumer.new(
      email: "johndoe@mail.com",
      phone: 12345678910,
      first_name: "FName",
      last_name: "LName"
    )
  end

  let(:item) do
    Afterpay::Item.new(
      name: "Item Name",
      sku: 1,
      price: Money.from_amount(1000, "AUD")
    )
  end

  subject(:order) do
    described_class.new(
      total: Money.from_amount(1000, "AUD"),
      consumer: consumer,
      items: [item],
      success_url: "http://example.com/success",
      cancel_url: "http://example.com/cancel"
    )
  end

  describe "#create" do
    it "returns a valid Order", :vcr do
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
  end

  describe "#find" do
    let(:token) { "tgiibd59adl9rldhefaqm9jcgnhca8dvv07t9gcq7lboo6btsdfq" }
    it "fetches order from server", :vcr do
      fetched_order = described_class.find(token)

      expect(fetched_order).to be_a Afterpay::Order
      expect(fetched_order.consumer.email).to eq(order.consumer.email)
      expect(fetched_order.token).to eq(order.token)
    end
  end
end
