module Tatami
  module Parsers
    module Csv
      module Assertions
        class DateTimeAssertionParser
          def self.parse(header, row)
            validate(header, row)
            a = [ Tatami::Models::Assertions::DateTimeAssertion.new(
                :name => Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::NAME, row),
                :is_list => Tatami::Models::Csv::Header.get_bool(header, Tatami::Constants::HeaderNames::IS_LIST, row),
                :is_time => Tatami::Models::Csv::Header.get_bool(header, Tatami::Constants::HeaderNames::IS_TIME, row),
                :expected => Tatami::Parsers::Csv::Assertions::ContentAssertionItemParser.parse(Tatami::Models::Csv::Header.search(header, Tatami::Constants::HeaderNames::EXPECTED), row),
                :actual => Tatami::Parsers::Csv::Assertions::ContentAssertionItemParser.parse(Tatami::Models::Csv::Header.search(header, Tatami::Constants::HeaderNames::ACTUAL), row)) ]
            a
          end

          def self.validate(header, row)
            name = Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::NAME, row)
            raise ArgumentError 'Invalid Data Format. Value of <Name> has no value.' if name.nil? or name == ''
          end
        end
      end
    end
  end
end