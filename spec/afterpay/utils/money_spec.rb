require "spec_helper"

RSpec.describe Afterpay::Utils::Money do
  describe ".from_response" do
    it "makes Money" do
      money_response = {
        amount: "1000.0",
        currency: "AUD"
      }

      result = Afterpay::Utils::Money.from_response(money_response)

      expect(result).to be_a Money
      expect(result.to_f).to eq 1000.0
    end
  end

  describe ".api_hash" do
    it "returns makes Hash from Money" do
      money = Money.from_amount(100, "AUD")

      hash = Afterpay::Utils::Money.api_hash(money)

      expect(hash[:amount]).to eq(100.0)
      expect(hash[:currency]).to eq("AUD")
    end
  end
end
