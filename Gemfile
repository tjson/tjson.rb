# frozen_string_literal: true

source "https://rubygems.org"
ruby RUBY_VERSION

gemspec

group :development do
  gem "guard-rspec"
end

group :development, :test do
  gem "rake"
  gem "rspec", "~> 3.5"
  gem "rubocop", "0.48.1"
  gem "toml-rb", "~> 2"
end
