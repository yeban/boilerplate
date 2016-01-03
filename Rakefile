require_relative 'lib/app'

def runtime
  @runtime ||= App::Runtime.new
end

desc 'Migrate database.'
task 'db:migrate' do
  runtime.repository.migrate ENV['version']
end

desc 'IRb.'
task 'irb' do
  runtime.irb
end

desc 'Serve.'
task 'serve', [:uri] do |t, args|
  runtime.serve
end

desc 'Run unit tests for Ruby code.'
task 'test' do
  require 'minitest/autorun'
  Dir.glob('tests/test_*.rb').each { |file| require_relative file}
end
