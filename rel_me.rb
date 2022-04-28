# frozen_string_literal: true

class RelMe < Roda
  # Routing plugins
  plugin :head
  plugin :not_allowed
  plugin :public
  plugin :status_handler
  plugin :type_routing, exclude: [:xml]

  # Rendering plugins
  plugin :render

  # Request/Response plugins
  plugin :caching
  plugin :halt

  # plugin :content_security_policy

  plugin :default_headers,
         'Content-Type' => 'text/html; charset=utf-8',
         'Referrer-Policy' => 'no-referrer-when-downgrade',
         'X-Frame-Options' => 'DENY',
         'X-XSS-Protection' => '0'

  # Other plugins
  plugin :environments
  plugin :heartbeat

  # Third-party plugins
  plugin :sprockets,
         css_compressor: :sassc,
         debug: false,
         precompile: %w[application.css apple-touch-icon-180x180.png icon.png]

  configure do
    use Rack::CommonLogger
  end

  route do |r|
    r.public
    r.sprockets unless opts[:environment] == 'production'

    r.root do
      response.cache_control public: true

      view :index
    end
  end

  status_handler(404) do |r|
    response.cache_control public: true

    error = { message: 'The requested URL could not be found' }

    r.json { error.to_json }

    view :not_found, locals: error
  end

  status_handler(405, keep_headers: ['Allow']) do |r|
    error = { message: 'The requested method is not allowed' }

    r.json { error.to_json }

    error[:message]
  end
end
