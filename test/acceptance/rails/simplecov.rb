# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  command_name "#{ENV.fetch('SIMPLECOV_COMMAND_NAME')} rails:dbconsole"
end

module KernelExec
  def exec(*)
    SimpleCov.result.format!
    super
  end
end

Kernel.prepend KernelExec
