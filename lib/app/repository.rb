require 'sequel'
require 'delegate'

module App
  # Decorates the object returned by `Sequel.connect` with methods to migrate
  # the database and load models.
  class Repository < SimpleDelegator
    def initialize(uri,
                   migrations: "#{__dir__}/migrations",
                   models: "#{__dir__}/models",
                   logger: $stderr)
      @db = Sequel.connect(uri, loggers: logger)
      @migrations, @models = migrations, models
      Sequel.datetime_class = DateTime
      super @db
      migrate; load_models
    end

    def load_models
      Sequel::Model.db = @db
      Sequel::Model.plugin :json_serializer
      Dir["#{@models}/*.rb"].each do |model|
        require_relative model
      end
    rescue Sequel::DatabaseConnectionError
      puts "Couldn't connect to database."
      exit
    end

    def migrate(version = nil)
      Sequel.extension :migration
      Sequel::Migrator.apply(@db, @migrations, version)
    rescue Sequel::DatabaseConnectionError
      puts "Couldn't connect to database."
      exit
    end
  end
end
