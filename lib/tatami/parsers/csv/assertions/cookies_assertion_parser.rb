module Tatami
  module Parsers
    module Csv
      module Assertions
        class CookiesAssertionParser
          include Tatami::Constants::HeaderNames

          def self.parse(header, row)
            hash = Tatami::Models::Csv::Header.get_hash(header, COOKIES, row)
            return nil if hash.empty?
            list = []
            hash.each { |k, v| list.push(Tatami::Models::Assertions::CookieAssertion.new(:key => k, :value => v)) }
            list
          end
        end
      end
    end
  end
end