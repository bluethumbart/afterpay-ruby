require "spec_helper"

RSpec.describe Afterpay::Item do
  let(:amount) { Money.from_amount(200) }
  subject(:item) do
    described_class.new(
      name: "Item Name",
      sku: 1,
      price: amount,
      page_url: "https://merchant.example.com/carabiner-354193.html",
      image_url: "https://merchant.example.com/carabiner-7378-391453-1.jpg",
      categories: [
        ["Sporting Goods", "Climbing Equipment", "Climbing", "Climbing Carabiners"],
        %w[Sale Climbing]
      ],
      estimated_shipment_date: "2021-03-01"
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
      quantity: 2,
      page_url: "https://merchant.example.com/carabiner-354193.html",
      image_url: "https://merchant.example.com/carabiner-7378-391453-1.jpg",
      categories: [
        ["Sporting Goods", "Climbing Equipment", "Climbing", "Climbing Carabiners"],
        %w[Sale Climbing]
      ],
      estimated_shipment_date: "2021-03-01"
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
      expect(result[:page_url]).to eq(item.page_url)
      expect(result[:image_url]).to eq(item.image_url)
      expect(result[:categories]).to eq(item.categories)
      expect(result[:estimated_shipment_date]).to eq(item.estimated_shipment_date)
    end
  end
end
