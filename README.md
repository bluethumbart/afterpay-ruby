[![Build Status](https://travis-ci.org/bluethumbart/afterpay-ruby.svg?branch=master)](https://travis-ci.org/bluethumbart/afterpay-ruby)
[![Coverage Status](https://coveralls.io/repos/github/bluethumbart/afterpay-ruby/badge.svg?branch=master)](https://coveralls.io/github/bluethumbart/afterpay-ruby?branch=master)
[![Gem Version](https://badge.fury.io/rb/afterpay-ruby.svg)](https://badge.fury.io/rb/afterpay-ruby)

# Afterpay Ruby

Based on the [API docs](https://docs.afterpay.com/au-online-api-v1.html)

Afterpay Ruby is a Ruby wrapper for Afterpay API. It provides simple DSL and serialization to Afterpay's API attribute.

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
end
```

### Creating an Order

[api docs](https://docs.afterpay.com/au-online-api-v1.html#create-order)

Order accepts a [Consumer](https://github.com/bluethumbart/afterpay-ruby#consumer-object) and an array of [Item](https://github.com/bluethumbart/afterpay-ruby#item-object) object which are required.

```ruby
order = Afterpay::Order.create(
  total: <Money>,
  consumer: <Afterpay::Consumer>,
  items: [<Afterpay::Item>],
  success_url: <String>,
  cancel_url: <String>,
  reference: <String>,
  tax: <Money | optional>,
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

### Consumer Object

[api docs](https://docs.afterpay.com/au-online-api-v1.html#consumer-object)

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

[api docs](https://docs.afterpay.com/au-online-api-v1.html#item-object)

Item holds the details of purchace per item.

```ruby
Afterpay::Item.new(
  name: <String>,
  price: <Money>,
  sku: <String | optional>,
  quantity: <Number | defaults to 1>,
)
```

### Discount Object

[api docs](https://docs.afterpay.com/au-online-api-v1.html#discount-object)

Discount Applied to the Order

```ruby
Afterpay::Discount.new(
  name: <String>,
  amount: <Money>
)
```

### Address Object

[api docs](https://docs.afterpay.com/au-online-api-v1.html#contact-object)

Item holds the details of purchace per item.

```ruby
Afterpay::Address.new(
  name: <String>,
  line_1: <String>,
  line_2: <String | optional>,
  suburb: <String | optional>,
  state: <String>,
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
