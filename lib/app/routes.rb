require 'json'
require 'sinatra/base'

module App
  class Routes < Sinatra::Base
    # See
    # http://www.sinatrarb.com/configuration.html
    configure do
      # We don't need Rack::MethodOverride. Let's avoid the overhead.
      disable :method_override

      # Ensure exceptions never leak out of the app. Exceptions raised within
      # the app must be handled by the app. We do this by attaching error
      # blocks to exceptions we know how to handle and attaching to Exception
      # as fallback.
      disable :show_exceptions, :raise_errors

      # Make it a policy to dump to 'rack.errors' any exception raised by the
      # app so that error handlers don't have to do it themselves. But for it
      # to always work, Exceptions defined by us should not respond to `code`
      # or `http_status` methods. Error blocks must explicitly set http
      # status, if needed, by calling `status` method.
      enable :dump_errors

      # We don't want Sinatra do setup any loggers for us. We will use our own.
      set :logging, nil
    end

    # All routes return JSON response.
    before do
      content_type 'application/json'
    end

    # Returns all posts.
    get '/posts' do
      posts = Post.all
      posts.to_json
    end

    # Returns data for the given post id.
    get '/posts/:id' do |id|
      post = Post.with_pk id
      post.to_json
    end

    # Creates a new post given title and text. Returns id.
    post '/post' do
      post = Post.create(JSON.parse(request.body.read))
      post.id.to_json
    end

    # This will catch any unhandled error and some very special errors. Ideally
    # we will never hit this block. If we do, it's a bug or something really
    # weird is going on in which case we show the stacktrace to the user
    # requesting them to post the same to our Google Group.
    error Exception do
      status 500
      env['sinatra.error']
    end
  end
end
