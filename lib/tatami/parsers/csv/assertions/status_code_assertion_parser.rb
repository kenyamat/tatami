module Tatami
  module Parsers
    module Csv
      module Assertions
        class StatusCodeAssertionParser
          include Tatami::Constants::HeaderNames

          def self.parse(header, row)
            value = Tatami::Models::Csv::Header.get_string(header, STATUS_CODE, row)
            return nil if value.nil?
            begin
              value = Integer(value, 10).to_s
            rescue => ex
              raise Tatami::WrongFileFormatError, 'Invalid Data Format. Value of <StatusCode> is not numeric. value=%s' % value
            end
            [ Tatami::Models::Assertions::StatusCodeAssertion.new(:value => value) ]
          end
        end
      end
    end
  end
end