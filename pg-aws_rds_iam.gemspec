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

  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://rubydoc.info/gems/pg-aws_rds_iam/#{PG::AWS_RDS_IAM::VERSION}"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0").reject { |path| path.start_with?("test/") } }

  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.6"

  spec.add_dependency "aws-sdk-rds", "~> 1.0"
  spec.add_dependency "pg", ">= 0.18", "< 2.0"
end
