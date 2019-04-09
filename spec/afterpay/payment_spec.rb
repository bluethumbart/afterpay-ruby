require "spec_helper"

RSpec.describe Afterpay::Payment do
  describe ".execute" do
    let(:token) { "tgiibd59adl9rldhefaqm9jcgnhca8dvv07t9gcq7lboo6btsdfq" }

    context "invalid token" do
      it "returns error", :vcr do
        payment = described_class.execute(token: token, reference: "checkout-1")

        expect(payment).to be_a Afterpay::Payment
        expect(payment.success?).to be false
        expect(payment.error).not_to be_nil
      end
    end
  end
end
