# frozen_string_literal: true

module PG
  module AWS_RDS_IAM
    module ActiveRecordPostgreSQLAdapter
      def dbconsole(config, *)
        AuthTokenInjector.new.inject_into_psql_env! config.configuration_hash, ENV
        super
      end
    end

    private_constant :ActiveRecordPostgreSQLAdapter
  end
end
