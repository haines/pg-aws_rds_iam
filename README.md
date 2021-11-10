# PG::AWS_RDS_IAM

[![Gem](https://img.shields.io/gem/v/pg-aws_rds_iam?style=flat-square)](https://rubygems.org/gems/pg-aws_rds_iam)
&ensp;
[![Docs](https://img.shields.io/badge/yard-docs-blue?style=flat-square)](https://haines.github.io/pg-aws_rds_iam/)

`PG::AWS_RDS_IAM` is a plugin for the [`pg` gem](https://rubygems.org/gems/pg) that adds support for [IAM authentication](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html) when connecting to PostgreSQL databases hosted in Amazon RDS.

IAM authentication allows your application to connect to the database using secure, short-lived authentication tokens instead of a fixed password.
This gives you greater security and eliminates the operational overhead of rotating passwords.

## Installation

Install manually:

```console
$ gem install pg-aws_rds_iam
```

or with Bundler:

```console
$ bundle add pg-aws_rds_iam
```

## Usage

To use IAM authentication for your database connections, you need to

1. enable IAM authentication for your database,
2. provide your application with IAM credentials, and
3. configure your application to generate authentication tokens.

### 1. Enable IAM authentication for your database

Start by configuring your database to allow IAM authentication using either the [AWS console](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.Enabling.html#UsingWithRDS.IAMDBAuth.Enabling.Console) or the [`aws` CLI](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.Enabling.html#UsingWithRDS.IAMDBAuth.Enabling.CLI).
This doesn't require downtime so is safe to apply immediately, unless you already have pending modifications that require a database reboot.

Next, [grant your database user the `rds_iam` role](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.DBAccounts.html#UsingWithRDS.IAMDBAuth.DBAccounts.PostgreSQL).

### 2. Provide your application with IAM credentials

The most secure way to grant your application permission to connect to your database is to use an IAM role.

Start by [creating a service role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-service.html) if your application doesn't already have one.
Then, create an [IAM policy granting the `rds-db:connect` permission](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.IAMPolicy.html) and attach it to the role.

If you've created a new service role, you'll need to associate it with your application.
The way to do this depends on where you are running your application:

* for EC2 instances, [set up an instance profile](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html);
* for EKS pods, [associate the IAM role with a Kubernetes service account](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html);
* for ECS tasks, [configure a task role](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html); or
* for Lambda functions, [set the execution role](https://docs.aws.amazon.com/lambda/latest/dg/lambda-intro-execution-role.html).

If you can't use a service role, then you can grant the permissions to an IAM user instead and supply the application with their access key through a [configuration profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) or via the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables.
However, you won't get the full security and operational benefits of RDS IAM authentication, because the access key is a long-lived secret that you need to supply to the application securely and rotate periodically.

### 3. Configure your application to generate authentication tokens

You can use `PG::AWS_RDS_IAM`'s default authentication token generator if you are using a service role as described above, or if you configure your application using the standard AWS ways to provide [credentials](https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/setup-config.html#aws-ruby-sdk-setting-credentials) and [region](https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/setup-config.html#aws-ruby-sdk-setting-region).

To use the default authentication token generator, set the `aws_rds_iam_auth_token_generator` connection parameter to `default`.
You can set this parameter in

* the query string of a connection URI:

  ```
  postgresql://andrew@postgresql.example.com:5432/blog?aws_rds_iam_auth_token_generator=default
  ```

* a `key=value` pair in a connection string:

  ```
  user=andrew host=postgresql.example.com port=5432 dbname=blog aws_rds_iam_auth_token_generator=default
  ```

* a `key: value` pair in a connection hash:

  ```ruby
  PG.connect(
    user: "andrew",
    host: "postgresql.example.com",
    port: 5432,
    dbname: "blog",
    aws_rds_iam_auth_token_generator: "default"
  )
  ```

* `database.yml`, if you're using Rails:

  ```yaml
  production:
    adapter: postgresql
    username: andrew
    host: postgresql.example.com
    port: 5432
    database: blog
    aws_rds_iam_auth_token_generator: default
  ```

If the default authentication token generator doesn't meet your needs, you can register an alternative with

```ruby
PG::AWS_RDS_IAM.auth_token_generators.add :custom do
  PG::AWS_RDS_IAM::AuthTokenGenerator.new(credentials: ..., region: ...)
end
```

To use this alternative authentication token generator, set the `aws_rds_iam_auth_token_generator` connection parameter to the name you registered it with (`custom`, in this example).

The block you give to `add` must construct and return the authentication token generator, which can either be an instance of `PG::AWS_RDS_IAM::AuthTokenGenerator` or another object that returns a string token in response to `call(host:, port:, user:)`.
The block will be called once, when the first token is generated, and the returned authentication token generator will be re-used to generate all future tokens.

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `bin/rake` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bin/rake install`.
To release a new version, update the version number in `version.rb`, and then run `bin/rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome [on GitHub](https://github.com/haines/pg-aws_rds_iam).
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/haines/pg-aws_rds_iam/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
