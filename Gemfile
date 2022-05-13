# frozen_string_literal: true

source "https://rubygems.org"
gemspec

gem "aws-sdk-ec2"
gem "bundler"
gem "commonmarker"
gem "minitest"
gem "minitest-reporters"
gem "pry"
gem "rake"
gem "rubocop"
gem "rubocop-minitest"
gem "rubocop-rake"
gem "timecop"
gem "yard"

["activerecord", "pg"].each do |gem_name|
  gem gem_name, *ENV["#{gem_name.upcase}_VERSION"]&.then { |gem_version| "~> #{gem_version}.0" }
end
