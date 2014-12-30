module Tatami
  module Parsers
    module Csv
      module Assertions
        class TextAssertionParser
          def self.parse(header, row)
            validate(header, row)
            [ Tatami::Models::Assertions::TextAssertion.new(
                :name => Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::NAME, row),
                :is_list => Tatami::Models::Csv::Header.get_bool(header, Tatami::Constants::HeaderNames::IS_LIST, row),
                :expected => Tatami::Parsers::Csv::Assertions::ContentAssertionItemParser.parse(Tatami::Models::Csv::Header.search(header, Tatami::Constants::HeaderNames::EXPECTED), row),
                :actual => Tatami::Parsers::Csv::Assertions::ContentAssertionItemParser.parse(Tatami::Models::Csv::Header.search(header, Tatami::Constants::HeaderNames::ACTUAL), row)) ]
          end

          def self.validate(header, row)
            name = Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::NAME, row)
            raise Tatami::Parsers::WrongFileFormatError, 'Invalid Data Format. Value of <Name> has no value.' if name.to_s.strip == ''
          end
        end
      end
    end
  end
end