# frozen_string_literal: true

module PG
  module AWS_RDS_IAM
    module Connection
      def conndefaults
        super + [{
          keyword: "aws_rds_iam_auth_token_generator",
          envvar: nil,
          compiled: nil,
          val: nil,
          label: "AWS-RDS-IAM-auth-token-generator",
          dispchar: "",
          dispsize: 64
        }]
      end

      def parse_connect_args(*)
        AuthTokenInjector.call(super)
      end
    end

    private_constant :Connection
  end
end
