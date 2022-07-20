# frozen_string_literal: true

require_relative "connection_info/active_record_configuration_hash"
require_relative "connection_info/keyword_value_string"
require_relative "connection_info/parse_error"
require_relative "connection_info/uri"

module PG
  module AWS_RDS_IAM
    module ConnectionInfo
      def self.from_connection_string(connection_string)
        if URI.match?(connection_string)
          URI.new(connection_string)
        else
          KeywordValueString.new(connection_string)
        end
      end

      def self.from_active_record_configuration_hash(configuration_hash)
        ActiveRecordConfigurationHash.new(configuration_hash)
      end
    end

    private_constant :ConnectionInfo
  end
end
