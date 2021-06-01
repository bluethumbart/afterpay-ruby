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

  describe ".execute_auth" do
    let(:merchant_reference) { "100101468" }

    it "returns a payment", :vcr do
      token = "002.avpv776th25fof4itbfvrc019dqje4ia27qjk5525o3mfosr"
      payment = described_class.execute_auth(request_id: "fjfwwwjfj0902929210", token: token,
                                             merchant_reference: merchant_reference)

      expect(payment.success?).to be true
      expect(payment.payment_state).to eq("AUTH_APPROVED")
      expect(payment).to be_a Afterpay::Payment
      expect(payment.order).to be_a Afterpay::Order
      expect(payment.error).to be_nil
    end

    context "invalid order token" do
      it "returns error", :vcr do
        token = "tgiibd59adl9rldhefaqm9jcgnhca8dvv07t9gcq7lboo6btsdfq11"
        payment = described_class.execute_auth(request_id: "fjfwwwjfj0902929210", token: token,
                                               merchant_reference: merchant_reference)

        expect(payment).to be_a Afterpay::Payment
        expect(payment.success?).to be false
        expect(payment.error).not_to be_nil
      end
    end
  end

  describe ".execute_deffered_payment" do
    let(:merchant_reference) { "100101468" }
    let(:mony) { Money.from_amount(250, "USD") }
    let(:valid_order_id) { 100101529842 }

    it "returns a payment", :vcr do
      payment = described_class.execute_deffered_payment(request_id: "wert100101529590",
                                                         reference: merchant_reference, amount: mony,
                                                         payment_event_merchant_reference: "", order_id: valid_order_id)

      expect(payment.success?).to be true
      expect(payment).to be_a Afterpay::Payment
      expect(payment.order).to be_a Afterpay::Order
      expect(payment.error).to be_nil
    end

    context "invalid order ID" do
      it "returns error", :vcr do
        payment = described_class.execute_deffered_payment(request_id: "wert100101529590",
                                                           reference: merchant_reference, amount: mony,
                                                           payment_event_merchant_reference: "", order_id: valid_order_id + 1)

        expect(payment).to be_a Afterpay::Payment
        expect(payment.success?).to be false
        expect(payment.error).not_to be_nil
      end
    end
  end

  describe ".execute_void" do
    let(:mony) { Money.from_amount(250, "USD") }
    let(:valid_order_id) { 100101529842 }

    it "returns a payment", :vcr do
      payment = described_class.execute_void(request_id: "some_uniqe_val",
                                             order_id: valid_order_id, amount: mony)

      expect(payment).to be_a Afterpay::Payment
      expect(payment.error).to be_nil
    end
  end
end
