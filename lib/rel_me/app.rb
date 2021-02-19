module RelMe
  class App < Sinatra::Base
    HTTP_HEADERS_OPTS = {
      accept: '*/*',
      user_agent: 'rel="me" (https://rel-me.cc)'
    }.freeze

    configure do
      set :root, File.dirname(File.expand_path('..', __dir__))

      set :raise_errors, true
      set :raise_sinatra_param_exceptions, true
      set :show_exceptions, :after_handler
    end

    register Sinatra::Param
    register Sinatra::RespondWith

    before do
      raise MethodNotAllowed unless request.head? || request.get?
    end

    after do
      halt(406, { 'Content-Type' => 'text/plain' }, 'The requested format is not supported') if status == 500 && body.include?('Unknown template engine')
    end

    get '/', provides: :html do
      cache_control :public

      respond_with :index
    end

    get '/search', provides: [:html, :json] do
      param :url, required: true, transform: :strip, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

      uri = Addressable::URI.parse(params[:url])
      rsp = HTTP.follow(max_hops: 20).headers(HTTP_HEADERS_OPTS).timeout(connect: 5, read: 5).get(uri)

      canonical_url = rsp.uri.to_s
      rel_me_urls = MicroMicro.parse(rsp.body.to_s, canonical_url).relationships.group_by_rel[:me] || []

      respond_with :search, rel_me_urls: rel_me_urls, canonical_url: canonical_url do |format|
        format.json { json rel_me_urls }
      end
    rescue Addressable::URI::InvalidURIError,
           Sinatra::Param::InvalidParameterError
      raise BadRequest, 'Parameter url is required and must be a valid URL (e.g. https://example.com)'
    rescue HTTP::ConnectionError,
           HTTP::TimeoutError,
           HTTP::Redirector::TooManyRedirectsError
      raise RequestTimeout, 'The request timed out and could not be completed'
    end

    error 400 do
      respond_with :'400', error: { code: 400, message: env['sinatra.error'].message }
    end

    error 404 do
      cache_control :public

      respond_with :'404', error: { code: 404, message: 'The requested URL could not be found' }
    end

    error 405 do
      halt 405, { 'Content-Type' => 'text/plain' }, 'The requested method is not allowed'
    end

    error 408 do
      respond_with :'408', error: { code: 408, message: env['sinatra.error'].message }
    end
  end
end
