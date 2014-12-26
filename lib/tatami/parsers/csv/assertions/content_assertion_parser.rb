module Tatami
  module Parsers
    module Csv
      module Assertions
        class ContentAssertionItemParser
          def self.parse(header, row)
            return nil if header.nil?
            Tatami::Models::Assertions::ContentAssertionItem.new(
                :key => Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::KEY, row),
                :value => Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::VALUE, row),
                :query => Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::QUERY, row),
                :attribute => Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::ATTRIBUTE, row),
                :exists => Tatami::Models::Csv::Header.get_nullable_bool(header, Tatami::Constants::HeaderNames::EXISTS, row),
                :pattern => Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::PATTERN, row),
                :format => Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::FORMAT, row),
                :format_culture => Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::FORMAT_CULTURE, row),
                :url_decode => Tatami::Models::Csv::Header.get_bool(header, Tatami::Constants::HeaderNames::URL_DECODE, row))
          end
        end
      end
    end
  end
end