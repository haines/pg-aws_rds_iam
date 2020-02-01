# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"
require "yard"

namespace :test do
  Rake::TestTask.new :acceptance do |t|
    t.description = "Run acceptance tests"
    t.libs << "test"
    t.test_files = ["test/acceptance/test.rb"]
  end

  Rake::TestTask.new :unit do |t|
    t.description = "Run unit tests"
    t.libs << "test"
    t.test_files = FileList["test/**/*_test.rb"]
  end
end

desc "Run all tests"
task :test => ["test:unit", "test:acceptance"]

RuboCop::RakeTask.new do |t|
  t.formatters = ["fuubar"]
end

desc "Generate documentation"
YARD::Rake::YardocTask.new

namespace :yard do
  desc "Run documentation server"
  task :server do
    exec "bin/yard", "server", "--reload"
  end
end

task :default => ["test:unit", :rubocop]
