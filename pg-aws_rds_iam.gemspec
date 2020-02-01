# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pg/aws_rds_iam/version"

Gem::Specification.new do |spec|
  spec.name = "pg-aws_rds_iam"
  spec.version = PG::AWS_RDS_IAM::VERSION
  spec.authors = ["Andrew Haines"]
  spec.email = ["andrew@haines.org.nz"]

  spec.summary = "IAM authentication for PostgreSQL on Amazon RDS"
  spec.description = "PG::AWS_RDS_IAM is a plugin for the pg gem that adds support for IAM authentication when connecting to PostgreSQL databases hosted in Amazon RDS."
  spec.homepage = "https://github.com/haines/pg-aws_rds_iam"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0").reject { |path| path.start_with?("test/") } }

  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk-rds", "~> 1.0"
  spec.add_dependency "pg", ">= 0.18", "< 2.0"

  spec.add_development_dependency "activerecord", ">= 5.2", "< 7.0"
  spec.add_development_dependency "aws-sdk-ec2", "~> 1.137"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "minitest", "~> 5.14"
  spec.add_development_dependency "minitest-reporters", "~> 1.4"
  spec.add_development_dependency "pry", "~> 0.12"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 0.79"
  spec.add_development_dependency "timecop", "~> 0.9"
  spec.add_development_dependency "yard", "~> 0.9"
end
