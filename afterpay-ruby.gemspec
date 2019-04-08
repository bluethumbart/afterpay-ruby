lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "afterpay/version"

Gem::Specification.new do |spec|
  spec.name          = "afterpay-ruby"
  spec.version       = Afterpay::VERSION
  spec.authors       = ["Eli"]
  spec.email         = ["iamchoongg@gmail.com"]

  spec.summary       = "Afterpay ruby wrapper"
  spec.homepage      = "https://github.com/choonggg/afterpay-ruby"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/choonggg/afterpay-ruby"
    # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.5", ">= 3.5.1"
  spec.add_development_dependency "pry"

  spec.add_dependency "faraday", ">= 0.8", "< 1.0"
  spec.add_dependency "faraday_middleware", "~> 0.13.1"
  spec.add_dependency "money", ">= 6.7.1", "< 7.0.0"
end
