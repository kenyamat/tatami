module Tatami
  module Parsers
    module Csv
      module Assertions
        class DateTimeAssertionParser
          include Tatami::Constants::HeaderNames
          
          def self.parse(header, row)
            validate(header, row)
            [ Tatami::Models::Assertions::DateTimeAssertion.new(
              :name => Tatami::Models::Csv::Header.get_string(header, NAME, row),
              :is_list => Tatami::Models::Csv::Header.get_bool(header, IS_LIST, row),
              :is_time => Tatami::Models::Csv::Header.get_bool(header, IS_TIME, row),
              :expected => Tatami::Parsers::Csv::Assertions::ContentAssertionItemParser.parse(Tatami::Models::Csv::Header.search(header, EXPECTED), row),
              :actual => Tatami::Parsers::Csv::Assertions::ContentAssertionItemParser.parse(Tatami::Models::Csv::Header.search(header, ACTUAL), row)) ]
          end

          def self.validate(header, row)
            name = Tatami::Models::Csv::Header.get_string(header, NAME, row)
            raise Tatami::Parsers::WrongFileFormatError, 'Invalid Data Format. Value of <Name> has no value.' if name.to_s.strip == ''
          end
        end
      end
    end
  end
end