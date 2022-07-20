# frozen_string_literal: true

module PG
  module AWS_RDS_IAM
    module ConnectionInfo
      class ActiveRecordConfigurationHash
        def initialize(configuration_hash)
          @configuration_hash = configuration_hash
        end

        def auth_token_generator_name
          @configuration_hash[:aws_rds_iam_auth_token_generator]
        end

        def user
          @configuration_hash[:username]
        end

        def host
          @configuration_hash[:host]
        end

        def port
          @configuration_hash[:port]
        end
      end
    end
  end
end
