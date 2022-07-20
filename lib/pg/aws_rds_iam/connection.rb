# frozen_string_literal: true

module PG
  module AWS_RDS_IAM
    module Connection
      def conndefaults
        super + [conndefault_aws_rds_iam_auth_token_generator]
      end

      def conninfo_parse(connection_string)
        connection_info = ConnectionInfo.from_connection_string(connection_string)

        super(connection_info.to_s).tap do |result|
          result << conndefault_aws_rds_iam_auth_token_generator.merge(val: connection_info.auth_token_generator_name) if connection_info.auth_token_generator_name
        end
      end

      def parse_connect_args(*args)
        AuthTokenInjector.new.inject_into_connection_string(super)
      end

      private

      def conndefault_aws_rds_iam_auth_token_generator
        {
          keyword: "aws_rds_iam_auth_token_generator",
          envvar: nil,
          compiled: nil,
          val: nil,
          label: "AWS-RDS-IAM-auth-token-generator",
          dispchar: "",
          dispsize: 64
        }
      end
    end

    private_constant :Connection
  end
end
