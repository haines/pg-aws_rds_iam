# frozen_string_literal: true

module PG
  module AWS_RDS_IAM
    module ActiveRecordPostgreSQLDatabaseTasks
      private

      def psql_env
        super.tap do |psql_env|
          AuthTokenInjector.new.inject_into_psql_env! configuration_hash, psql_env
        end
      end
    end
  end
end
