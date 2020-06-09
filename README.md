# ramverk-database

Database integration (Sequel) for the Ramverk framework.

## Status

[![Build Status](https://travis-ci.org/ramverk/ramverk-database.svg?branch=master)](https://travis-ci.org/ramverk/ramverk-database)
[![codecov](https://codecov.io/gh/ramverk/ramverk-database/branch/master/graph/badge.svg)](https://codecov.io/gh/ramverk/ramverk-database)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "ramverk-database"
```

## Usage

```ruby
require "ramverk"
require "ramverk/database"

class Application < Ramverk::Application
  extend Ramverk::Database

  # Available options and their defaults
  config.database.connection = ENV["DATABASE_URL"]
  config.database.migrations_path = "db/migrations"
  config.database.seeds_file = "db/seeds.rb"
  config.database.logging = true
  config.database.sql_log_level = :debug
end

Ramverk.application.boot

Ramverk.application[:database] # => <Sequel::Database>
```

### Rake tasks

```bash
$ rake -T

rake db:create           # Create the database
rake db:drop             # Drop the database
rake db:migrate          # Migrate the database up
rake db:migration[name]  # Generate a migration file
rake db:reset            # Reset the database, drop:create:migrate:seed
rake db:rollback[n]      # Rollback the database n steps (1 by default)
rake db:seed             # Seed the database from file
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ramverk/ramverk-database. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
