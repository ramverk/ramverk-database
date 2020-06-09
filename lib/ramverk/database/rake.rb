# frozen_string_literal: true

require "fileutils"

namespace :db do
  Sequel.extension :migration

  task :connect do
    DB = Sequel.connect(configuration.connection) unless defined?(DB)
  end

  task :check do
    abort "task not allowed in production" if Ramverk.env?(:production)
  end

  desc "Generate a migration file"
  task :migration, %i[name] do |t, args|
    abort "missing migration name: db:migration[create_books]" unless args[:name]

    path = configuration.migrations_path
    time = Time.now.to_i
    name = "#{time}_#{args[:name].downcase}.rb"
    file = File.join(path, name)

    FileUtils.mkdir_p(path)
    File.write file, <<~RUBY
      # frozen_string_literal: true

      # https://sequel.jeremyevans.net/rdoc/files/doc/migration_rdoc.html
      Sequel.migration do
        change do
        end
      end
    RUBY
  end

  desc "Create the database"
  task :create do
    database = configuration.connection[:database]
    config = configuration.connection.dup
    config[:database] = "postgres" if config[:adapter] == "postgres"

    conn = Sequel.connect(config)
    conn.execute "CREATE DATABASE #{database}"

    puts "created database '#{database}'"
  end

  desc "Drop the database"
  task drop: :check do
    database = configuration.connection[:database]
    config = configuration.connection.dup
    config[:database] = "postgres" if config[:adapter] == "postgres"

    conn = Sequel.connect(config)
    conn.execute "DROP DATABASE #{database}"

    puts "dropped database '#{database}'"
  end

  desc "Migrate the database up"
  task migrate: :connect do
    migrate

    puts "migration complete"
  end

  desc "Rollback the database n steps (1 by default)"
  task :rollback, %i[n] => :connect do |t, args|
    step = args[:n]&.to_i || 1

    target_migration = DB[:schema_migrations].reverse_order(:filename)
                                             .offset(step)
                                             .first

    if target_migration
      version = Integer(target_migration[:filename].match(/([\d]+)/)[0])
    end

    migrate(version)

    puts "rollback complete"
  end

  desc "Reset the database, drop:create:migrate:seed"
  task reset: %i[check drop create migrate seed]

  desc "Seed the database from file"
  task :seed do
    configuration.logging = false
    Ramverk.application.boot

    file = Ramverk.application[:root].join(configuration.seeds_file)
    load file if File.exist?(file)

    puts "seed complete"
  end

  def migrate(version = nil)
    Sequel::Migrator.apply(DB, configuration.migrations_path, version)
  end

  def database
    Ramverk.application[:database]
  end

  def configuration
    Ramverk.application.configuration.database
  end
end
