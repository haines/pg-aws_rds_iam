# frozen_string_literal: true

module PG
  module AWS_RDS_IAM
    module ActiveRecordPostgreSQLAdapterPatch
      # Hook into the PostgreSQL adapter to generate IAM tokens for Rails 7.2+
      #
      # Rails 7.2 changed the connection lifecycle in a way that breaks the gem's
      # PG::Connection.connect hook. This patch intercepts at the ActiveRecord
      # adapter level to generate tokens before the connection is established.
      #
      # Key insight: After setting the password, we must DELETE the
      # aws_rds_iam_auth_token_generator parameter from @connection_parameters
      # to prevent the gem's PG::Connection hook from interfering.

      private

      def connect
        inject_iam_token_if_needed
        super
      end

      def reconnect
        inject_iam_token_if_needed
        super
      end

      def inject_iam_token_if_needed
        generator_name = @config[:aws_rds_iam_auth_token_generator]
        return unless generator_name.present?

        generator = PG::AWS_RDS_IAM::AuthTokenGenerator.new(
          credentials: Aws::CredentialProviderChain.new.resolve,
          region: @config[:region] || ENV.fetch("AWS_REGION", "us-east-1")
        )

        @connection_parameters[:password] = generator.call(
          host: @connection_parameters[:host],
          port: (@connection_parameters[:port] || 5432).to_i,
          user: @connection_parameters[:user]
        )

        # Remove trigger so gem's PG::Connection hook doesn't interfere
        @connection_parameters.delete(:aws_rds_iam_auth_token_generator)
      end
    end
  end
end

require "active_record/connection_adapters/postgresql_adapter"

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend(
  PG::AWS_RDS_IAM::ActiveRecordPostgreSQLAdapterPatch
)
