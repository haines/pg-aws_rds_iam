# frozen_string_literal: true

module PG
  module AWS_RDS_IAM
    # Generates short-lived authentication tokens for connecting to Amazon RDS instances.
    #
    # @see https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html
    class AuthTokenGenerator
      # Creates a new authentication token generator.
      #
      # @param credentials [Aws::CredentialProvider] the IAM credentials with which to sign the token
      # @param region [String] the AWS region in which the RDS instances are running
      def initialize(credentials:, region:)
        @generator = Aws::RDS::AuthTokenGenerator.new(credentials:)
        @region = region
        @mutex = Mutex.new
        @cache = {}
      end

      # Generates an authentication token for connecting to an Amazon RDS instance.
      # Generated tokens are cached and reused until 1 minute before they are due to expire.
      #
      # @param host [String] the host name of the RDS instance that you want to access
      # @param port [String] the port number used for connecting to your RDS instance
      # @param user [String] the database account that you want to access
      # @return [String] the generated authentication token
      def call(host:, port:, user:)
        endpoint = "#{host}:#{port}"
        key = "#{user}@#{endpoint}"

        token = cached_token(key)
        return token if token

        @mutex.synchronize do
          token = cached_token(key)
          break token if token

          @generator.auth_token(region: @region, endpoint:, user_name: user).tap do |new_token|
            @cache[key] = AuthToken.new(new_token)
          end
        end
      end

      private

      def cached_token(key)
        token = @cache[key]
        token.to_str if token&.valid?
      end
    end
  end
end
