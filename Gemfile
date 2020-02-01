# frozen_string_literal: true

source "https://rubygems.org"
gemspec

["activerecord", "pg"].each do |gem_name|
  gem_version = ENV["#{gem_name.upcase}_VERSION"]
  gem gem_name, "~> #{gem_version}.0" if gem_version
end
