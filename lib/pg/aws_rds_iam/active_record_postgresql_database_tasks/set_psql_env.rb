# frozen_string_literal: true

module PG
  module AWS_RDS_IAM
    module ActiveRecordPostgreSQLDatabaseTasks
      private

      def set_psql_env
        super
        hash = respond_to?(:configuration_hash, true) ? configuration_hash : configuration.symbolize_keys
        AuthTokenInjector.new.inject_into_psql_env! hash, ENV
      end
    end
  end
end
