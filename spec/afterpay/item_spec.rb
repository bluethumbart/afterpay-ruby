require "spec_helper"

RSpec.describe Afterpay::Item do
  let(:amount) { Money.from_amount(200) }
  subject(:item) do
    described_class.new(
      name: "Item Name",
      sku: 1,
      price: amount
    )
  end

  it "sets a default quantity" do
    expect(item.quantity).to eq(1)
  end

  it "allows overriding quantity" do
    item.quantity = 2
    expect(item.quantity).to eq(2)
  end

  it "initializes with quantity" do
    instance = Afterpay::Item.new(
      name: "Item Name",
      sku: 1,
      price: amount,
      quantity: 2
    )
    expect(instance.quantity).to eq(2)
  end

  describe "#to_hash" do
    it "transforms to afterpay compliant data" do
      result = item.to_hash

      expect(result[:name]).to eq(item.name)
      expect(result[:sku]).to eq(item.sku)
      expect(result[:quantity]).to eq(item.quantity)
      expect(result[:price][:amount]).to eq(amount.to_f)
      expect(result[:price][:currency]).to eq(amount.currency)
    end
  end
end
