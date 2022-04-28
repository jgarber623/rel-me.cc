# frozen_string_literal: true

RSpec.describe RelMe, roda: :app do
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
  end
end
