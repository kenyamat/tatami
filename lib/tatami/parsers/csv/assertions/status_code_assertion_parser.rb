module Tatami
  module Parsers
    module Csv
      module Assertions
        class StatusCodeAssertionParser
          def self.parse(header, row)
            value = Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::STATUS_CODE, row)
            return nil if value.nil?

            begin
              value = Integer(value, 10).to_s
            rescue => ex
              raise ArgumentError 'Invalid Data Format. Value of <StatusCode> is not numeric. value=%s' % value
            end

            [ Tatami::Models::Assertions::UriAssertion.new(:value => value) ]
          end
        end
      end
    end
  end
end