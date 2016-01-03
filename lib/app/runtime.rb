require_relative 'logger'
require_relative 'repository'
require_relative 'routes'
require_relative 'server'

module App
  # Brings all components together and is the entrypoint into the application.
  class Runtime
    def initialize(**config)
      @config = defaults.merge config
    end

    attr_reader :config

    def environment
      ENV['RACK_ENV']
    end

    def development?
      environment == 'development'
    end

    def root
      File.expand_path "#{__dir__}/../.."
    end

    def logger
      @logger ||= Logger.new($stderr, development?)
    end

    def repository
      @repostiry ||= Repository.new(config[:db], logger: logger)
    end

    def call(env)
      env['rack.logger'] = logger
      Routes.call(env)
    end

    def server
      @server ||= Server.new(self)
    end

    def irb
      ARGV.clear
      require 'irb'
      IRB.setup nil
      repository.load_models
      IRB.conf[:MAIN_CONTEXT] = IRB::Irb.new.context
      require 'irb/ext/multi-irb'
      IRB.irb nil, self
    end

    def serve
      repository.load_models
      server.start
    end

    private

    def defaults
      {
        db: "sqlite://#{root}/db",
        host: '0.0.0.0',
        port: '9292'
      }
    end
  end
end
