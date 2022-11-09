# frozen_string_literal: true

RSpec.describe RelMeApp, roda: :app do
  describe 'GET /search' do
    let(:example_url) { 'https://example.com' }

    context 'when no url param' do
      let(:request) { get '/search' }

      include_examples 'a bad request'
    end

    context 'when invalid url param protocol' do
      let(:request) { get '/search', url: 'ftp://example.com' }

      include_examples 'a bad request'
    end

    context 'when invalid url param' do
      let(:request) { get '/search', url: 'https://example.com<script>' }

      include_examples 'a bad request'
    end

    context 'when request timeout' do
      let(:message) { 'The request timed out and could not be completed' }

      before do
        stub_request(:get, example_url).to_timeout
      end

      context 'when requesting text/html' do
        before do
          header 'Accept', 'text/html'
          get '/search', url: example_url
        end

        # it { is_expected.to be_request_timeout }
        its(:body) { is_expected.to include(message) }
      end

      context 'when requesting application/json' do
        before do
          header 'Accept', 'application/json'
          get '/search', url: example_url
        end

        # it { is_expected.to be_request_timeout }
        its(:body) { is_expected.to eq({ message: message }.to_json) }
      end
    end

    context 'when valid url param' do
      before do
        stub_request(:get, example_url).to_return(
          headers: {
            content_type: 'text/html',
            link: [
              '<https://www.flickr.com/photos/jgarber>; rel="me"',
              '<https://github.com/jgarber623>; rel="me authn"'
            ]
          },
          body: <<~HTML
            <html>
            <body>
              <a rel="me" href="https://twitter.com/jgarber">Twitter</a>
              <a rel="me" href="https://indieweb.org/User:Sixtwothree.org">IndieWeb</a>
            </body>
            </html>
          HTML
        )
      end

      context 'when requesting text/html' do
        before do
          header 'Accept', 'text/html'
          get '/search', url: example_url
        end

        it { is_expected.to be_ok }
        its(:body) { is_expected.to include('https://www.flickr.com/photos/jgarber') }
      end

      context 'when requesting application/json' do
        # NOTE: WebMock (or some other tool in the test suite) is alphabetically
        # sorting the Link headers defined above. So, github.com before
        # www.flickr.com, but ONLY here in this test.
        let(:rel_me_urls) do
          [
            'https://github.com/jgarber623',
            'https://www.flickr.com/photos/jgarber',
            'https://twitter.com/jgarber',
            'https://indieweb.org/User:Sixtwothree.org'
          ]
        end

        before do
          header 'Accept', 'application/json'
          get '/search', url: example_url
        end

        it { is_expected.to be_ok }
        its(:body) { is_expected.to eq(rel_me_urls.to_json) }
      end
    end
  end
end
