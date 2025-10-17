# frozen_string_literal: true

source "https://rubygems.org"
gemspec

gem "aws-sdk-ec2"
gem "base64"
gem "bigdecimal"
gem "bundler"
gem "commonmarker", "< 1.0" # https://github.com/lsegal/yard/issues/1528
gem "minitest"
gem "minitest-reporters"
gem "mutex_m"
gem "openssl"
gem "pry"
gem "rake"
gem "rexml"
gem "rubocop"
gem "rubocop-minitest"
gem "rubocop-rake"
gem "sequel"
gem "simplecov", require: false
gem "timecop"
gem "webrick"
gem "yard"

def gem_version(gem_name)
  ENV["#{gem_name.upcase}_VERSION"]&.then { |gem_version| "~> #{gem_version}.0" }
end

["activerecord", "pg"].each do |gem_name|
  gem gem_name, *gem_version(gem_name)
end

gem "railties", *gem_version("activerecord")
