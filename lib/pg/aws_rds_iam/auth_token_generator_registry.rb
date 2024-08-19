# frozen_string_literal: true

module PG
  module AWS_RDS_IAM
    # Registers {AuthTokenGenerator}s to be used to generate authentication tokens for `PG::Connection`s that have the
    # `aws_rds_iam_auth_token_generator` connection parameter set to the registered name.
    class AuthTokenGeneratorRegistry
      # Creates a new `AuthTokenRegistry`.
      #
      # @param default_auth_token_generator_class [Class] the class to register as the default {AuthTokenGenerator}
      def initialize(default_auth_token_generator_class: AuthTokenGenerator)
        @default_auth_token_generator_class = default_auth_token_generator_class
        reset
      end

      # Registers an {AuthTokenGenerator}.
      #
      # @param name [String, Symbol]
      # @return [void]
      # @yieldreturn [AuthTokenGenerator]
      def add(name, &)
        @registry[name.to_s] = Memoizer.new(&)
      end

      # Looks up an {AuthTokenGenerator} by name.
      #
      # @param name [String, Symbol]
      # @return [AuthTokenGenerator]
      def fetch(name)
        @registry.fetch(name.to_s).call
      end

      # Unregisters an {AuthTokenGenerator}.
      #
      # @param name [String, Symbol]
      # @return [void]
      def remove(name)
        @registry.delete name.to_s
      end

      # Unregisters all {AuthTokenGenerator}s and re-registers the default {AuthTokenGenerator}.
      #
      # @return [void]
      def reset
        @registry = {}

        add :default do
          config = Aws::RDS::Client.new.config
          @default_auth_token_generator_class.new(credentials: config.credentials, region: config.region)
        end
      end

      class Memoizer # rubocop:disable Style/Documentation
        def initialize(&block)
          @block = block
        end

        def call
          return @call if defined?(@call)

          @call = @block.call
        end
      end

      private_constant :Memoizer
    end
  end
end
