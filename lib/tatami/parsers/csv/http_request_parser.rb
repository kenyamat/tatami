module Tatami
  module Parsers
    module Csv
      class HttpRequestParser
        def self.parse(header, row, name)
          raise ArgumentError, 'header must not be null.' if header.to_s.strip == ''
          raise ArgumentError, 'row must not be null.' if row.to_s.strip == ''
          raise ArgumentError, 'name must no be null.' if name.to_s.strip == ''

          is_empty = true
          (header.from..header.to).each { |i|
            if row[i].to_s.strip != ''
              is_empty = false
              break
            end
          }

          return nil if is_empty
          validate(header, row, name)
          method = Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::METHOD, row)

          Tatami::Models::HttpRequest.new(
            :name => name,
            :base_uri => Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::BASE_URI, row),
            :method => method,
            :user_agent => Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::USER_AGENT, row),
            :headers => Tatami::Models::Csv::Header.get_hash(header, Tatami::Constants::HeaderNames::HEADERS, row),
            :cookies => Tatami::Models::Csv::Header.get_hash(header, Tatami::Constants::HeaderNames::COOKIES, row),
            :path_infos => Tatami::Models::Csv::Header.get_string_list(header, Tatami::Constants::HeaderNames::PATH_INFOS, row),
            :query_strings => Tatami::Models::Csv::Header.get_hash(header, Tatami::Constants::HeaderNames::QUERY_STRINGS, row),
            :fragment => Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::FRAGMENT, row),
            :content => Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::CONTENT, row))
        end

        def self.validate(header, row, name)
          base_uri = Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::BASE_URI, row)
          if base_uri.nil?
            raise Tatami::Parsers::WrongFileFormatError, '<BaseUri> should be not null. name=%s' % [name]
          end
        end
      end
    end
  end
end