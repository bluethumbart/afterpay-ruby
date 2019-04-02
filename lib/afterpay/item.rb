module Afterpay
  class Item
    attr_accessor :name, :sku, :quantity, :price

    def initialize(name:, sku:, price:, quantity: 1)
      @name = name
      @sku = sku
      @quantity = quantity
      @price = price
    end

    def to_hash
      {
        name: name,
        sku: sku,
        quantity: quantity,
        price: {
          amount: price.to_f,
          currency: price.currency
        }
      }
    end
  end
end
