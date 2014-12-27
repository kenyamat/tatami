module Tatami
  module Parsers
    module Csv
      module Assertions
        class AssertionsParser
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
                  when Tatami::Constants::HeaderNames::URI
                    assertions = Tatami::Parsers::Csv::Assertions::UriAssertionParser.parse(header, row)
                  when Tatami::Constants::HeaderNames::STATUS_CODE
                    assertions = Tatami::Parsers::Csv::Assertions::StatusCodeAssertionParser.parse(header, row)
                  when Tatami::Constants::HeaderNames::HEADERS
                    assertions = Tatami::Parsers::Csv::Assertions::HeadersAssertionParser.parse(header, row)
                  when Tatami::Constants::HeaderNames::COOKIES
                    assertions = Tatami::Parsers::Csv::Assertions::CookiesAssertionParser.parse(header, row)
                  when Tatami::Constants::HeaderNames::XSD
                    assertions = Tatami::Parsers::Csv::Assertions::XsdAssertionParser.parse(header, row, resources)
                  when Tatami::Constants::HeaderNames::CONTENTS
                    if Tatami::Models::Csv::Header.get_bool(header, Tatami::Constants::HeaderNames::IS_DATE_TIME, row) or
                        Tatami::Models::Csv::Header.get_bool(header, Tatami::Constants::HeaderNames::IS_TIME, row)
                      assertions = Tatami::Parsers::Csv::Assertions::DateTimeAssertionParser.parse(header, row)
                    else
                      assertions = Tatami::Parsers::Csv::Assertions::TextAssertionParser.parse(header, row)
                    end
                  else
                    raise ArgumentError, 'Invalid Assertion name. name=%s' % [assertion_header_item.name]
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