require "spec_helper"

RSpec.describe Afterpay::MoneyUtil do
  describe "#from_response" do
    it "makes Money" do
      money_response = {
        amount: "1000.0",
        currency: "AUD"
      }

      result = Afterpay::MoneyUtil.from_response(money_response)

      expect(result).to be_a Money
      expect(result.to_f).to eq 1000.0
    end
  end
end
