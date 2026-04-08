# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "rake"

group :development do
  gem "pry"
end

group :docs do
  gem "redcarpet"
  gem "webrick"
  gem "yard"
end

group :lint do
  gem "rubocop"
  gem "rubocop-minitest"
  gem "rubocop-rake"
end

group :test do
  def gem_version(gem_name)
    ENV["#{gem_name.upcase}_VERSION"]&.then { |gem_version| "~> #{gem_version}.0" }
  end

  gem "activerecord", *gem_version("activerecord")
  gem "aws-sdk-ec2"
  gem "base64"
  gem "bigdecimal"
  gem "minitest"
  gem "minitest-reporters"
  gem "mutex_m"
  gem "openssl"
  gem "pg", *gem_version("pg")
  gem "railties", *gem_version("activerecord")
  gem "rexml"
  gem "sequel"
  gem "timecop"
end

group :test, :coverage do
  gem "simplecov", require: false
end
