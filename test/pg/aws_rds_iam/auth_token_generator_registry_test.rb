# frozen_string_literal: true

require "test_helper"

module PG
  module AWS_RDS_IAM
    class AuthTokenGeneratorRegistryTest < Minitest::Test
      def setup
        @registry = AuthTokenGeneratorRegistry.new(
          default_auth_token_generator_class: Struct.new(:credentials, :region, keyword_init: true)
        )
      end

      def test_default_auth_token_generator_pulls_credentials_and_config_from_environment
        with_env(
          "AWS_ACCESS_KEY_ID" => "AKIAIOSFODNN7EXAMPLE",
          "AWS_SECRET_ACCESS_KEY" => "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
          "AWS_REGION" => "eu-west-2"
        ) do
          generator = @registry.fetch(:default)

          assert_equal "AKIAIOSFODNN7EXAMPLE", generator.credentials.access_key_id
          assert_equal "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY", generator.credentials.secret_access_key
          assert_equal "eu-west-2", generator.region
        end
      end

      def test_add_auth_token_generators
        a = Object.new
        @registry.add :a do
          a
        end

        b = Object.new
        @registry.add :b do
          b
        end

        assert_equal a, @registry.fetch(:a)
        assert_equal b, @registry.fetch(:b)
      end

      def test_fetch_raises_error_when_not_registered
        assert_raises KeyError do
          @registry.fetch :unknown
        end
      end

      def test_block_is_only_executed_on_fetch
        executed = false

        @registry.add :test do
          executed = true
        end

        refute executed

        @registry.fetch :test

        assert executed
      end

      def test_block_is_only_executed_once
        executions = 0

        @registry.add :test do
          executions += 1
        end

        @registry.fetch :test
        @registry.fetch :test

        assert_equal 1, executions
      end

      def test_remove_auth_token_generator
        a = Object.new
        @registry.add :a do
          a
        end

        @registry.add :b do
          Object.new
        end

        @registry.remove :b

        assert_equal a, @registry.fetch(:a)
        assert_raises KeyError do
          @registry.fetch :b
        end
      end

      def test_indifferent_access
        names = [:example, "example"]
        names.product names, names do |name_to_add, name_to_fetch, name_to_remove|
          generator = Object.new
          @registry.add name_to_add do
            generator
          end

          assert_equal generator, @registry.fetch(name_to_fetch)

          @registry.remove(name_to_remove)

          assert_raises KeyError do
            @registry.fetch name_to_fetch
          end
        end
      end

      private

      def with_env(variables)
        env = ENV.to_h
        ENV.update variables
        yield
      ensure
        ENV.clear
        ENV.update env
      end
    end
  end
end
