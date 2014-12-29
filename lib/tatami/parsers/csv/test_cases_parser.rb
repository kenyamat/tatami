module Tatami
  module Parsers
    module Csv
      class TestCasesParser
        def self.parse(data, resources = nil)
          raise ArgumentError, 'data should not be null.' if data.nil? or data.empty? or data[0].empty?

          header = Tatami::Parsers::Csv::HeaderParser.parse(data)
          Tatami::Validators::Csv::HeaderValidator.validate(header)
          cases = Tatami::Models::TestCases.new
          last_start_index = 0
          (Tatami::Parsers::Csv::HeaderParser::HEADER_ROW_COUNT..(data.length - 1)).each { |i|
            row = data[i]
            if row[0].to_s.strip != ''
              if i != Tatami::Parsers::Csv::HeaderParser::HEADER_ROW_COUNT
                cases.test_cases.push(Tatami::Parsers::Csv::TestCaseParser.parse(header, data.slice(last_start_index, i - last_start_index), resources))
              end
              last_start_index = i
            end
          }
          cases.test_cases.push(Tatami::Parsers::Csv::TestCaseParser.parse(header, data.slice(last_start_index, data.length - last_start_index), resources))
          cases
        end
      end
    end
  end
end