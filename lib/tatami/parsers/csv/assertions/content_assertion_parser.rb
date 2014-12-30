module Tatami
  module Parsers
    module Csv
      module Assertions
        class ContentAssertionItemParser
          include Tatami::Constants::HeaderNames

          def self.parse(header, row)
            return nil if header.nil?
            Tatami::Models::Assertions::ContentAssertionItem.new(
                :key => Tatami::Models::Csv::Header.get_string(header, KEY, row),
                :value => Tatami::Models::Csv::Header.get_string(header, VALUE, row),
                :query => Tatami::Models::Csv::Header.get_string(header, QUERY, row),
                :attribute => Tatami::Models::Csv::Header.get_string(header, ATTRIBUTE, row),
                :exists => Tatami::Models::Csv::Header.get_nullable_bool(header, EXISTS, row),
                :pattern => Tatami::Models::Csv::Header.get_string(header, PATTERN, row),
                :format => Tatami::Models::Csv::Header.get_string(header, FORMAT, row),
                :format_culture => Tatami::Models::Csv::Header.get_string(header, FORMAT_CULTURE, row),
                :url_decode => Tatami::Models::Csv::Header.get_bool(header, URL_DECODE, row))
          end
        end
      end
    end
  end
end