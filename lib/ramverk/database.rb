# frozen_string_literal: true

require "sequel"

module Ramverk
  # Database (Sequel) integration for Ramverk
  module Database
    require_relative "database/version"
    require_relative "database/configuration"
    require_relative "database/rake" if Ramverk.rake?

    def self.extended(app)
      app.configuration.database = Configuration.new

      app.on :post_boot do |app|
        conn = Sequel.connect(app.configuration.database.connection)
        conn.logger = app[:logger] if app.configuration.database.logging
        conn.sql_log_level = app.configuration.database.sql_log_level

        # We do not freeze the connection if being booted via a Rake task since
        # it will log connection information.
        conn.freeze unless Ramverk.rake?

        app[:database] = conn
      end
    end
  end
end
