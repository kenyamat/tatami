module Tatami
  module Parsers
    module Csv
      module Assertions
        class HeadersAssertionParser
          def self.parse(header, row)
            hash = Tatami::Models::Csv::Header.get_hash(header, Tatami::Constants::HeaderNames::HEADERS, row)
            return nil if hash.empty?
            list = []
            hash.each { |k, v| list.push(Tatami::Models::Assertions::HeaderAssertion.new(:key => k, :value => v)) }
            list
          end
        end
      end
    end
  end
end