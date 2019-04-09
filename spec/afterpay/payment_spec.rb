require "spec_helper"

RSpec.describe Afterpay::Payment do
  describe ".execute" do
    it "returns a payment", :vcr do
      token = "q3f6gn81q09gfjk7riaqfhavmtebt88qpjepd9kmjo37ou7oj5eb"
      payment = described_class.execute(token: token, reference: "checkout-1")

      expect(payment.success?).to be true
      expect(payment).to be_a Afterpay::Payment
      expect(payment.order).to be_a Afterpay::Order
      expect(payment.error).to be_nil
    end

    context "invalid token" do
      it "returns error", :vcr do
        token = "tgiibd59adl9rldhefaqm9jcgnhca8dvv07t9gcq7lboo6btsdfq"
        payment = described_class.execute(token: token, reference: "checkout-1")

        expect(payment).to be_a Afterpay::Payment
        expect(payment.success?).to be false
        expect(payment.error).not_to be_nil
      end
    end
  end
end
