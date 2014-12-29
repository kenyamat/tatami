module Tatami
  module Parsers
    module Csv
      class TestCaseParser
        def self.parse(header, data, resources)
          raise ArgumentError, 'header should not be null.' if header.to_s.strip == ''
          raise ArgumentError, 'data should not be null.' if data.to_s.strip == ''
          if data.length == 0 or data[0].length == 0 or data[0][0].to_s.strip == ''
            raise ArgumentError, 'Test case\'s format is invalid. data.Count == 0 || data[0].Count == 0 || string.IsNullOrWhiteSpace(data[0][0]).'
          end
          Tatami::Models::TestCase.new(
              :name => data[0][0],
              :arranges => Tatami::Parsers::Csv::ArrangesParser.parse(header.children[0], data[0]),
              :assertions => Tatami::Parsers::Csv::Assertions::AssertionsParser.parse(header.children[1], data, resources))
        end
      end
    end
  end
end