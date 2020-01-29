# frozen_string_literal: true

module PG
  module AWS_RDS_IAM
    module Connection
      def parse_connect_args(*)
        AuthTokenInjector.call(super)
      end
    end

    private_constant :Connection
  end
end
