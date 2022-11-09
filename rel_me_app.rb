# frozen_string_literal: true

class RelMeApp < Roda
  class InvalidURIError < StandardError; end

  HTTP_HEADERS_OPTS = {
    accept: '*/*',
    user_agent: 'rel=“me” Link Discovery (https://rel-me.cc)'
  }.freeze

  # Routing plugins
  plugin :head
  plugin :not_allowed
  plugin :status_handler
  plugin :type_routing, exclude: [:xml]

  # Rendering plugins
  plugin :h
  plugin :link_to
  plugin :public
  plugin :render, engine: 'html.erb'

  # Request/Response plugins
  plugin :caching
  plugin :halt

  plugin :content_security_policy do |csp|
    csp.base_uri :self
    csp.block_all_mixed_content
    csp.child_src :none
    csp.default_src :self
    csp.font_src :self, 'https://fonts.gstatic.com'
    csp.form_action :self
    csp.frame_ancestors :none
    csp.frame_src :none
    csp.img_src :self
    csp.media_src :self
    csp.object_src :none
    csp.script_src :self
    csp.style_src :self, 'https://fonts.googleapis.com'
    csp.worker_src :none
  end

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

  # :nocov:
  configure :production do
    use Rack::Deflater
    use Rack::HostRedirect, [ENV.fetch('HOSTNAME', nil), 'www.rel-me.cc'].compact => 'rel-me.cc'
    use Rack::Static, urls: ['/assets'], root: 'public'
  end
  # :nocov:

  route do |r|
    r.public
    r.sprockets unless opts[:environment] == 'production'

    r.root do
      response.cache_control public: true

      view :index
    end

    r.get 'search' do
      uri = HTTP::URI.parse(r.params['url'].to_s)

      raise InvalidURIError unless uri.http? || uri.https?

      rsp = HTTP.follow(max_hops: 20).headers(HTTP_HEADERS_OPTS).timeout(connect: 5, read: 5).get(uri)

      urls_from_headers = LinkHeaderParser
                            .parse(rsp.headers.get('link'), base: rsp.uri)
                            .group_by_relation_type
                            .fetch(:me, [])
                            .map(&:target_uri)

      urls_from_body = Nokogiri::HTML(rsp.body.to_s, rsp.uri)
                         .resolve_relative_urls!
                         .css('[href][rel~="me"]')
                         .map { |node| node['href'] }

      rel_me_urls = (urls_from_headers + urls_from_body).compact

      r.json { rel_me_urls.to_json }

      view :search, locals: { canonical_url: rsp.uri.to_s, rel_me_urls: rel_me_urls }
    rescue InvalidURIError, Addressable::URI::InvalidURIError
      r.halt 400
    rescue HTTP::Error, OpenSSL::SSL::SSLError
      r.halt 408
    end
  end

  status_handler(400) do |r|
    error = { message: 'Parameter url is required and must be a valid URL (e.g. https://example.com)' }

    r.json { error.to_json }

    view :bad_request, locals: error
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

  status_handler(408) do |r|
    error = { message: 'The request timed out and could not be completed' }

    r.json { error.to_json }

    view :request_timeout, locals: error
  end
end
