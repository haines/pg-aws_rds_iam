# frozen_string_literal: true

require "rake/clean"

begin
  require "active_record/version"
  require "minitest/test_task"
  require "pg/version"

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
rescue LoadError
  # Bundle installed without test group
end

namespace :coverage do
  CLEAN.include "coverage"

  desc "Collate coverage reports"
  task :collate do
    require "simplecov"
    SimpleCov.collate Dir.glob("coverage-*/.resultset.json") do
      formatter SimpleCov::Formatter::HTMLFormatter
    end
  end
end

begin
  require "rubocop/rake_task"

  RuboCop::RakeTask.new do |t|
    t.formatters = ENV["CI"] ? ["github", "clang"] : ["fuubar"]
  end
rescue LoadError
  # Bundle installed without lint group
end

begin
  require "yard"

  CLEAN.include ".yardoc"
  CLOBBER.include "doc"

  desc "Generate documentation"
  YARD::Rake::YardocTask.new

  namespace :yard do
    desc "Run documentation server"
    task :server do
      exec "bin/yard", "server", "--reload"
    end
  end
rescue LoadError
  # Bundle installed without docs group
end

namespace :release do
  CLOBBER.include "pkg"

  built_gem_path = nil
  attestation_path = nil

  desc "Build gem"
  task :build do
    require "bundler/gem_helper"
    built_gem_path = Bundler::GemHelper.new.build_gem
  end

  desc "Sign gem"
  task :sign => :build do
    attestation_path = "#{built_gem_path}.sigstore.json"
    sh "cosign", "sign-blob", built_gem_path, "--bundle", attestation_path

    # https://github.com/rubygems/rubygems.org/issues/6369
    require "json"
    bundle = JSON.load_file(attestation_path)
    bundle.fetch("verificationMaterial").delete "timestampVerificationData"
    File.write attestation_path, JSON.generate(bundle)
  end

  desc "Push gem"
  task :push => :sign do
    sh "gem", "push", built_gem_path, "--attestation", attestation_path
  end

  desc "Extract release notes from changelog"
  task :notes do
    require "pg/aws_rds_iam/version"

    version = PG::AWS_RDS_IAM::VERSION

    mkdir_p "pkg", verbose: false

    lines = File.open "CHANGELOG.md", "r" do |changelog|
      changelog
        .each_line
        .lazy
        .drop_while { |line| !line.start_with?("## [#{version}] ") }
        .drop(1)
        .drop_while { |line| line == "\n" }
        .take_while { |line| !line.start_with?("## ") }
        .to_a
    end

    lines.pop while lines.last == "\n"

    File.open "pkg/release.md", "w" do |release_notes|
      lines.each do |line|
        release_notes << line
      end
    end

    File.write "pkg/version.txt", version
  end

  desc "Tag release"
  task :tag do
    require "pg/aws_rds_iam/version"

    version = PG::AWS_RDS_IAM::VERSION
    tag = "v#{version}"

    abort "Unclean working directory" unless system("git", "diff", "--quiet")

    sh "git", "fetch", "--quiet", "origin", "main"
    abort "Not on latest main" if `git rev-parse HEAD` != `git rev-parse FETCH_HEAD`

    sh "git", "tag", "--message=Version #{version}", "--sign", tag
    sh "git", "push", "origin", tag
  end
end

task :default => ["test:unit", :rubocop]
