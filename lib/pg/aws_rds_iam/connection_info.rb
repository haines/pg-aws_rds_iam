# frozen_string_literal: true

require_relative "connection_info/keyword_value_string"
require_relative "connection_info/parse_error"
require_relative "connection_info/uri"

module PG
  module AWS_RDS_IAM
    module ConnectionInfo
      def self.new(connection_string)
        if URI.match?(connection_string)
          URI.new(connection_string)
        else
          KeywordValueString.new(connection_string)
        end
      end
    end

    private_constant :ConnectionInfo
  end
end
