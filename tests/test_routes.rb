require 'json'
require 'rack/test'
require 'minitest/spec'

describe 'Routes' do
  ENV['RACK_ENV'] = 'test'
  include Rack::Test::Methods

  def app
    @app ||= App::Runtime.new(db: 'sqlite:/')
  end

  it 'should do something'
end
