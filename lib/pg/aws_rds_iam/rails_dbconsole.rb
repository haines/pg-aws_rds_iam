# frozen_string_literal: true

module PG
  module AWS_RDS_IAM
    module RailsDBConsole
      private

      def find_cmd_and_exec(*)
        AuthTokenInjector.new.inject_into_psql_env! db_config.configuration_hash, ENV
        super
      end
    end

    private_constant :RailsDBConsole
  end
end
