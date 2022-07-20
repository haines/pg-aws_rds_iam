# frozen_string_literal: true

require "aws-sdk-rds"
require "pg"
require "strscan"
require "uri"

require_relative "aws_rds_iam/auth_token_generator"
require_relative "aws_rds_iam/auth_token_generator_registry"
require_relative "aws_rds_iam/auth_token_injector"
require_relative "aws_rds_iam/connection"
require_relative "aws_rds_iam/connection_info"
require_relative "aws_rds_iam/version"

# The top-level [PG](https://deveiate.org/code/pg/PG.html) namespace.
module PG
  # The top-level AWS RDS IAM plugin namespace.
  module AWS_RDS_IAM
    @auth_token_generators = AuthTokenGeneratorRegistry.new

    # Registry of available {AuthTokenGenerator}s.
    #
    # @return [AuthTokenGeneratorRegistry]
    def self.auth_token_generators
      @auth_token_generators
    end

    PG::Connection.singleton_class.prepend Connection

    if defined?(ActiveRecord)
      require_relative "aws_rds_iam/active_record_postgresql_database_tasks"

      ActiveRecord::Tasks::PostgreSQLDatabaseTasks.prepend ActiveRecordPostgreSQLDatabaseTasks
    end
  end
end
