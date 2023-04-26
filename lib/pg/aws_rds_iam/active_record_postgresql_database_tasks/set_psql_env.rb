# frozen_string_literal: true

module PG
  module AWS_RDS_IAM
    module ActiveRecordPostgreSQLDatabaseTasks
      private

      def set_psql_env
        super
        AuthTokenInjector.new.inject_into_psql_env! configuration_hash, ENV
      end
    end
  end
end
