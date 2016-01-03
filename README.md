## App boilerplate

Backend boilerplate code for database-backed apps. It has five components:

- Logger: For logging anything.
- Routes: Controllers implemented with Sinatra.
- Server: WEBrick+Rack. Routes are hosted by the server.
- Repository: Interface to an SQL database using Sequel.
- Runtime: Given a config Hash, initialises all components of the app.

Testing is done with `minitest`.

### Requirements

- Ruby 2.1+
- SQLite 3

### Usage

#### Install dependencies.

    gem install bundler && bundle

#### Setup database.

    bundle exec rake db:migrate

#### Run the server.

    bundle exec rake serve

#### Run tests.

    bundle exec rake test
