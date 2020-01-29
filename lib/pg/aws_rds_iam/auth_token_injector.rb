# frozen_string_literal: true

module PG
  module AWS_RDS_IAM
    class AuthTokenInjector
      def self.call(connection_string, auth_token_generators: AWS_RDS_IAM.auth_token_generators)
        new(connection_string, auth_token_generators: auth_token_generators).call
      end

      def initialize(connection_string, auth_token_generators:)
        @connection_string = connection_string
        @connection_info = ConnectionInfo.new(connection_string)
        @connection_defaults = PG::Connection.conndefaults_hash
        @auth_token_generators = auth_token_generators
      end

      def call
        return @connection_string unless generate_auth_token?

        @connection_info.password = generate_auth_token

        @connection_info.to_s
      end

      private

      def generate_auth_token?
        @connection_info.auth_token_generator_name
      end

      def generate_auth_token
        @auth_token_generators
          .fetch(@connection_info.auth_token_generator_name)
          .call(
            user: @connection_info.user || default(:user),
            host: @connection_info.host || default(:host),
            port: @connection_info.port || default(:port)
          )
      end

      def default(key)
        @connection_defaults.fetch(key)
      end
    end

    private_constant :AuthTokenInjector
  end
end
