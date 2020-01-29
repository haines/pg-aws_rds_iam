# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"
require "yard"

Rake::TestTask.new :test do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
end

RuboCop::RakeTask.new do |t|
  t.formatters = ["fuubar"]
end

YARD::Rake::YardocTask.new

namespace :yard do
  desc "Run YARD documentation server"
  task :server do
    exec "bin/yard", "server", "--reload"
  end
end

task :default => [:test, :rubocop]
