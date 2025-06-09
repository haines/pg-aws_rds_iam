# frozen_string_literal: true

SimpleCov.start do
  command_name ENV.fetch("SIMPLECOV_COMMAND_NAME", nil)
  enable_coverage :branch
  formatter SimpleCov::Formatter::SimpleFormatter
end
