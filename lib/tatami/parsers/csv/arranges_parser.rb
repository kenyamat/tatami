module Tatami
  module Parsers
    module Csv
      class ArrangesParser
        def self.parse(header, data)
          raise ArgumentError, 'header must not be null.' if header.nil?
          raise ArgumentError, 'header.Children must not be null.' if header.children.nil?
          raise ArgumentError, 'header.Children must no be empty.' if header.children.empty?
          raise ArgumentError, 'data must not be null.' if data.nil?

          arranges = Tatami::Models::Arranges.new
          header.children.each { |http_request_header|
            case http_request_header.name
              when Tatami::Constants::HeaderNames::HTTP_REQUEST_EXPECTED
                arranges.expected = Tatami::Models::Arrange.new(
                  :name => 'Expected',
                  :http_request => Tatami::Parsers::Csv::HttpRequestParser.parse(header, data, Tatami::Constants::HeaderNames::EXPECTED))
              when Tatami::Constants::HeaderNames::HTTP_REQUEST_ACTUAL
                arranges.actual = Tatami::Models::Arrange.new(
                  :name => 'Actual',
                  :http_request => Tatami::Parsers::Csv::HttpRequestParser.parse(header, data, Tatami::Constants::HeaderNames::ACTUAL))
              else
                raise ArgumentError, 'Invalid HttpRequest name. Expected is \'HttpRequest Expected\' or \'HttpRequest Actual\'. name=%s' % [http_request_header.name]
            end
          }
          raise ArgumentError, 'HttpRequest Actual is empty.' if arranges.actual.nil?
          arranges
        end
      end
    end
  end
end