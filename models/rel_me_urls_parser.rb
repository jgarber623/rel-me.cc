# frozen_string_literal: true

class RelMeUrlsParser
  # @param response [HTTP::Response]
  def initialize(response)
    @response = response
  end

  # @return [Array<String>]
  def results
    @results ||= urls_from_response.compact! || urls_from_response
  end

  private

  attr_reader :response

  def urls_from_body
    Nokogiri::HTML(response.body.to_s, response.uri)
      .resolve_relative_urls!
      .css('[href][rel~="me"]')
      .map { |node| node['href'] }
  end

  def urls_from_headers
    LinkHeaderParser
      .parse(response.headers.get('link'), base: response.uri)
      .group_by_relation_type
      .fetch(:me, [])
      .map(&:target_uri)
  end

  def urls_from_response
    @urls_from_response ||= (urls_from_headers + urls_from_body).uniq
  end
end
