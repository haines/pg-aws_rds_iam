# frozen_string_literal: true

require "bundler/setup"

require "rails"
require "rails/command"
require "rails/commands/dbconsole/dbconsole_command"
require "active_record"

APP_PATH = File.expand_path("application", __dir__)

Rails::DBConsole.start
