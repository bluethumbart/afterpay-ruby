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

```ruby
Afterpay.configure do |config|
  config.app_id = <app_id>
  config.secret = <secret>

  # Sets to raise errors on request
  # config.raise_errors = true

  # Sets the environment for Afterpay
  # defaults to sandbox
  # config.env = "sandbox" # "live"
end
```

### Creating an Order



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/afterpay-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Afterpay::Ruby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/afterpay-ruby/blob/master/CODE_OF_CONDUCT.md).
