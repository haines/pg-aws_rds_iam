# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
* Require Ruby ≥ 3.1 ([#653](https://github.com/haines/pg-aws_rds_iam/pull/653))

## [0.5.0] - 2023-05-04

### Changed
* Require Ruby ≥ 3.0, Active Record ≥ 6.1, and PG ≥ 1.1 ([#492](https://github.com/haines/pg-aws_rds_iam/pull/492))

### Removed
* Development files that were unnecessarily included in the gem ([#498](https://github.com/haines/pg-aws_rds_iam/pull/498))

## [0.4.2] - 2023-01-10

### Changed
* Test against Ruby 3.2 ([#442](https://github.com/haines/pg-aws_rds_iam/pull/442))

### Fixed
* Handle empty host in connection URIs ([#442](https://github.com/haines/pg-aws_rds_iam/pull/442))

## [0.4.1] - 2022-07-20

### Fixed
* Generate auth token for Active Record structure load ([#374](https://github.com/haines/pg-aws_rds_iam/pull/374))

## [0.4.0] - 2022-06-22

### Changed
* Test against Ruby 3.1 ([#305](https://github.com/haines/pg-aws_rds_iam/pull/305))
* Require Ruby ≥ 2.7 and Active Record ≥ 6.0 ([#360](https://github.com/haines/pg-aws_rds_iam/pull/360))

### Fixed
* Compatibility with `pg` ≥ 1.4 ([#356](https://github.com/haines/pg-aws_rds_iam/pull/356))

## [0.3.2] - 2021-11-15

### Changed
* Require MFA to publish gem ([#278](https://github.com/haines/pg-aws_rds_iam/pull/278))

## [0.3.1] - 2021-11-10

### Fixed
* Make code snippets in README valid Ruby to fix syntax highlighting ([#274](https://github.com/haines/pg-aws_rds_iam/pull/274))

## [0.3.0] - 2021-11-10

### Changed
* Require Ruby ≥ 2.6 ([#216](https://github.com/haines/pg-aws_rds_iam/pull/216))

### Fixed
* Typos in README ([#272](https://github.com/haines/pg-aws_rds_iam/pull/272))

## [0.2.0] - 2021-01-29

### Changed
* Require Ruby ≥ 2.5 ([#177](https://github.com/haines/pg-aws_rds_iam/pull/177))
* Test against Ruby 3.0 and ActiveRecord 6.1 ([#180](https://github.com/haines/pg-aws_rds_iam/pull/180))

## [0.1.1] - 2020-02-05

### Added
* Badges to README and additional links to gemspec. ([#6](https://github.com/haines/pg-aws_rds_iam/pull/6))

## [0.1.0] - 2020-02-05

### Added
* A plugin for the [`pg` gem](https://rubygems.org/gems/pg) that adds support for [IAM authentication](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html) when connecting to PostgreSQL databases hosted in Amazon RDS. ([#1](https://github.com/haines/pg-aws_rds_iam/pull/1))
* ActiveRecord support. ([#3](https://github.com/haines/pg-aws_rds_iam/pull/3))

[Unreleased]: https://github.com/haines/pg-aws_rds_iam/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/haines/pg-aws_rds_iam/compare/v0.4.2...v0.5.0
[0.4.2]: https://github.com/haines/pg-aws_rds_iam/compare/v0.4.1...v0.4.2
[0.4.1]: https://github.com/haines/pg-aws_rds_iam/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/haines/pg-aws_rds_iam/compare/v0.3.2...v0.4.0
[0.3.2]: https://github.com/haines/pg-aws_rds_iam/compare/v0.3.1...v0.3.2
[0.3.1]: https://github.com/haines/pg-aws_rds_iam/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/haines/pg-aws_rds_iam/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/haines/pg-aws_rds_iam/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/haines/pg-aws_rds_iam/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/haines/pg-aws_rds_iam/compare/64168051a8ef5f32a13632d8ef0b7da00d0056bc...v0.1.0
