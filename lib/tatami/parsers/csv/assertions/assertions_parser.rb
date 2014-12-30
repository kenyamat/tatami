module Tatami
  module Parsers
    module Csv
      module Assertions
        class AssertionsParser
          include Tatami::Constants::HeaderNames
          include Tatami::Constants::ParserType

          def self.parse(header, data, resources)
            list = []
            data.each do |row|
              j = header.from - 1
              loop do
                j += 1
                break if j > row.length
                if row[j].nil?
                  next
                end
                assertion_header_item = Tatami::Models::Csv::Header.get_header(header, j, 1)
                case assertion_header_item.name
                  when URI
                    assertions = Tatami::Parsers::Csv::Assertions::UriAssertionParser.parse(header, row)
                  when STATUS_CODE
                    assertions = Tatami::Parsers::Csv::Assertions::StatusCodeAssertionParser.parse(header, row)
                  when HEADERS
                    assertions = Tatami::Parsers::Csv::Assertions::HeadersAssertionParser.parse(header, row)
                  when COOKIES
                    assertions = Tatami::Parsers::Csv::Assertions::CookiesAssertionParser.parse(header, row)
                  when XSD
                    assertions = Tatami::Parsers::Csv::Assertions::XsdAssertionParser.parse(header, row, resources)
                  when CONTENTS
                    if Tatami::Models::Csv::Header.get_bool(header, IS_DATE_TIME, row) or
                        Tatami::Models::Csv::Header.get_bool(header, IS_TIME, row)
                      assertions = Tatami::Parsers::Csv::Assertions::DateTimeAssertionParser.parse(header, row)
                    else
                      assertions = Tatami::Parsers::Csv::Assertions::TextAssertionParser.parse(header, row)
                    end
                  else
                    raise Tatami::Parsers::WrongFileFormatError, 'Invalid Assertion name. name=%s' % [assertion_header_item.name]
                end
                list.concat(assertions)
                j = header.to
              end
            end
            list
          end
        end
      end
    end
  end
end