# frozen_string_literal: true


# {
#   "name": "T-Shirt",
#   "sku": "12341234",
#   "quantity": 1,
#   "price": {
#     "amount": "10.00",
#     "currency": "AUD"
#   }
# }

# {
#   "name": "Blue Carabiner",
#   "sku": "12341234",
#   "quantity": 1,
#   "pageUrl": "https://merchant.example.com/carabiner-354193.html",
#   "imageUrl": "https://merchant.example.com/carabiner-7378-391453-1.jpg",
#   "price": {
#     "amount": "40.00",
#     "currency": "AUD"
#   },
#   "categories": [
#     ["Sporting Goods", "Climbing Equipment", "Climbing", "Climbing Carabiners"],
#     ["Sale", "Climbing"]
#   ],
#   "estimatedShipmentDate": "2021-03-01"
# }



require "money"

module Afterpay
  class Item
    attr_accessor :name, :sku, :quantity, :page_url, :image_url, :price, :categories, :estimated_shipment_date

    def initialize(name:, price:, sku: nil, quantity: 1, page_url:, image_url:, categories:, estimated_shipment_date:)
      @name = name
      @sku = sku
      @quantity = quantity
      @price = price
      @page_url = page_url
      @image_url = image_url
      @categories = categories
      @estimated_shipment_date = estimated_shipment_date
    end

    def to_hash
      {
        name: name,
        sku: sku,
        quantity: quantity,
        price: {
          amount: price.to_f,
          currency: price.currency
        },
        page_url: page_url,
        image_url: image_url,
        categories: categories,
        estimated_shipment_date: estimated_shipment_date
      }
    end

    # Builds Item from response
    def self.from_response(response)
      return nil if response.nil?

      new(
        name: response[:name],
        sku: response[:sku],
        quantity: response[:quantity],
        price: Utils::Money.from_response(response[:price]),
        page_url: response[:pageUrl],
        image_url: response[:imageUrl],
        categories: response[:categories],
        estimated_shipment_date: response[:estimatedShipmentDate]
      )
    end
  end
end
