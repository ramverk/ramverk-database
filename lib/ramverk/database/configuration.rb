# frozen_string_literal: true

require "uri"

module Ramverk
  module Database
    class Configuration
      attr_accessor :connection
      attr_accessor :migrations_path
      attr_accessor :seeds_file
      attr_accessor :logging
      attr_accessor :sql_log_level

      def initialize
        self.connection = ENV["DATABASE_URL"]

        @migrations_path = "db/migrations"
        @seeds_file = "sb/seeds.rb"
        @logging = true
        @sql_log_level = :debug
      end

      def connection=(value)
        if value.is_a?(String)
          parts = URI.parse(value)
          value = {
            adapter: parts.scheme,
            host: parts.host,
            database: parts.path.to_s[1..-1],
            user: parts.user,
            password: parts.password
          }
        end

        @connection = value
      end
    end
  end
end
