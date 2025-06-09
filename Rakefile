# frozen_string_literal: true

require "active_record/version"
require "bundler/gem_tasks"
require "minitest/test_task"
require "pg/version"
require "rubocop/rake_task"
require "yard"

namespace :test do
  {
    acceptance: ["test/acceptance/test.rb"],
    unit: ["test/**/*_test.rb"]
  }.each do |name, globs|
    Minitest::TestTask.create name do |t|
      t.test_globs = globs
      t.test_prelude = <<~RUBY
        ENV["SIMPLECOV_COMMAND_NAME"] = "test:#{name} ruby:#{RUBY_VERSION} pg:#{PG::VERSION} activerecord:#{ActiveRecord.version}"
        require "simplecov"
      RUBY
    end
  end
end

desc "Run all tests"
task :test => ["test:unit", "test:acceptance"]

RuboCop::RakeTask.new do |t|
  t.formatters = ENV["CI"] ? ["github", "clang"] : ["fuubar"]
end

desc "Generate documentation"
YARD::Rake::YardocTask.new

namespace :yard do
  desc "Run documentation server"
  task :server do
    exec "bin/yard", "server", "--reload"
  end
end

namespace :coverage do
  desc "Collate coverage reports"
  task :collate do
    require "simplecov"
    SimpleCov.collate Dir.glob("coverage-*/.resultset.json") do
      formatter SimpleCov::Formatter::HTMLFormatter
    end
  end
end

task :default => ["test:unit", :rubocop]
