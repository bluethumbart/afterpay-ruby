# Afterpay Ruby

Based on the [API docs](https://developers.afterpay.com/afterpay-online/reference)

Afterpay Ruby is a Ruby wrapper for Afterpay API. It provides simple DSL and serialization to Afterpay's API attribute. This version supports the v2 version of Afterpay API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'afterpay-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install afterpay-ruby

## Usage

You need to configure Afterpay using your Merchant ID and secret.

For Rails, put this in your initializer.

```ruby
Afterpay.configure do |config|
  config.app_id = <app_id>
  config.secret = <secret>

  # Sets the environment for Afterpay
  # defaults to sandbox
  # config.env = "sandbox" # "live"

  # Sets the user agent header for Afterpay requests
  # Refer https://developers.afterpay.com/afterpay-online/reference#configuration
  # config.user_agent_header = {pluginOrModuleOrClientLibrary}/{pluginVersion} ({platform}/{platformVersion}; Merchant/{merchantId}) { merchantUrl }
  # Example
  # config.user_agent_header = "Afterpay Module / 1.0.0 (rails/ 5.1.2; Merchant/#{ merchant_id }) #{ merchant_website_url }"

end
```

### Creating an Order

[api docs](https://YourMechanic/afterpay-ruby#create-checkout)

Order accepts a [Consumer](YourMechanic/afterpay-ruby#consumer-object) and an array of [Item](YourMechanic/afterpay-ruby#item-object) object which are required.

```ruby
order = Afterpay::Order.create(
  total: <Money>,
  consumer: <Afterpay::Consumer>,
  items: [<Afterpay::Item>],
  success_url: <String>,
  cancel_url: <String>,
  reference: <String>,
  tax: <Money>,
  shipping: <Money | optional>,
  discounts: [<Afterpay::Discount | optional>],
  billing_address: <Afterpay::Address | optional>,
  shipping_address: <Afterpay::Address | optional>,
)

# OR

order = Afterpay::Order.new(
  ...
)
order.create


order.success?
=> true
order.token
=> xxxxxxx

# Error

order.success?
=> false
order.error
=> Afterpay::Error:0x00007f8a63953888
  @id="48da0bce49d39625",
  @code="invalid_object",
  @message="merchant.redirectConfirmUrl must be a valid URL, merchant.redirectConfirmUrl may not be empty" >
```

### Executing Payment

```ruby
payment = Afterpay::Payment.execute(
  token: token <String>,
  reference: "checkout-1" <String>
)
=> <Afterpay::Payment ...>

payment.success?
=> true
payment.order
=> <Afterpay::Order ...>
payment.status
=> APPROVED
```

### Deferred Payment

mony = Money.from_amount(1000, "USD")

For Auth
Afterpay::Payment.execute_auth(request_id: 'fjfwwwjfj090292920', token: '002.v4krg5qpii1tbp0kvr261rf3p1k5jfe2fin', merchant_reference: '100101382')

For executing deferred payment
Afterpay::Payment.execute_deffered_payment(request_id: 'ppjjjkjk', reference: '100101382', amount: mony, payment_event_merchant_reference: '', order_id: 100101524323)

### Void payment

Afterpay::Payment.execute_void(request_id: 'ppjjjkjk', order_id: 'same_as_id_of_auth_output', amount: mony)

### Refund

Afterpay::Refund.execute(request_id: 'unique_id', order_id: 'order_id', amount: mony, merchant_reference: '100101382', refund_merchant_reference: '100101111')

### Consumer Object

[api docs](https://developers.afterpay.com/afterpay-online/reference#consumer-object)

Consumer contains the details of the payee which will be serialized to API's format.

```ruby
Afterpay::Consumer.new(
  email: <String>,
  phone: <String>,
  first_name: <String>,
  last_name: <String>,
)
```

### Item Object

[api docs](https://developers.afterpay.com/afterpay-online/reference#item-object)

Item holds the details of purchace per item.

```ruby
Afterpay::Item.new(
  name: <String>,
  price: <Money>,
  sku: <String | optional>,
  quantity: <Number | defaults to 1>,
  page_url: <String | optional>,
  image_url: <String | optional>,
  categories: [][],
  estimatedShipmentDate: <String | optional>
)
```

### Discount Object

[api docs](https://developers.afterpay.com/afterpay-online/reference#discount-object)

Discount Applied to the Order

```ruby
Afterpay::Discount.new(
  name: <String>,
  amount: <Money>
)
```

### Address Object

[api docs](https://developers.afterpay.com/afterpay-online/reference#contact-object)

Item holds the details of purchace per item.

```ruby
Afterpay::Address.new(
  name: <String>,
  line_1: <String>,
  line_2: <String | optional>,
  area_1: <String | required | Limited to 128 characters>,
  area_2: <String | optional | Limited to 128 characters>,
  region: <String | required | Limited to 128 characters>,
  postcode: <String | Number>,
  country: <String | optional>,
  phone: <String>
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bluethumbart/afterpay-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

You will need to copy `.env.sample` to `.env` for running Afterpay console. This will not be checked into git.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Afterpay project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/afterpay-ruby/blob/master/CODE_OF_CONDUCT.md).
