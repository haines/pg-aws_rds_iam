# PG::AWS_RDS_IAM

`PG::AWS_RDS_IAM` is a plugin for the [`pg` gem](https://rubygems.org/gems/pg) that adds support for [IAM authentication](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html) when connecting to PostgreSQL databases hosted in Amazon RDS.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pg-aws_rds_iam'
```

And then execute:

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install pg-aws_rds_iam
```

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `bin/rake test` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bin/rake install`.
To release a new version, update the version number in `version.rb`, and then run `bin/rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/haines/pg-aws_rds_iam.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/haines/pg-aws_rds_iam/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
