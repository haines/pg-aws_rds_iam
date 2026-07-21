# frozen_string_literal: true

SimpleCov.configure do
  command_name ENV.fetch("SIMPLECOV_COMMAND_NAME", nil)
  enable_coverage :branch
  enable_coverage :method
  formatter SimpleCov::Formatter::SimpleFormatter
end
