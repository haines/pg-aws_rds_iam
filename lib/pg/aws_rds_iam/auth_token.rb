# frozen_string_literal: true

module PG
  module AWS_RDS_IAM
    class AuthToken
      def initialize(token)
        @token = token
        @generated_at = now
        @expiry = parse_expiry || 900
      end

      def valid?
        (now - @generated_at) < (@expiry - 60)
      end

      def to_str
        @token
      end

      private

      def now
        Process.clock_gettime(Process::CLOCK_MONOTONIC)
      end

      def parse_expiry
        URI
          .decode_www_form(URI.parse("https://#{@token}").query)
          .lazy
          .filter_map { |(key, value)| Integer(value, 10) if key.downcase == "x-amz-expires" }
          .first
      rescue StandardError
        nil
      end
    end

    private_constant :AuthToken
  end
end
