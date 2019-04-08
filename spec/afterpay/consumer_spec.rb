require "spec_helper"

RSpec.describe Afterpay::Consumer do
  subject(:consumer) do
    described_class.new(
      email: "johndoe@mail.com",
      phone: 12345678910,
      first_name: "FName",
      last_name: "LName"
    )
  end

  describe "#to_hash" do
    it "transforms to afterpay compliant hash" do
      result = consumer.to_hash

      expect(result[:email]).to eq(consumer.email)
      expect(result[:phoneNumber]).to eq(consumer.phone)
      expect(result[:surname]).to eq(consumer.last_name)
      expect(result[:givenNames]).to eq(consumer.first_name)
    end
  end
end
