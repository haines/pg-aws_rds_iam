# frozen_string_literal: true

module PG
  module AWS_RDS_IAM
    module RailsDBConsole

      def db_config

        super.tap do |db_config|
          AuthTokenInjector.new.inject_into_env! db_config.configuration_hash
        end
      end
    end
  end
end
