module Tatami
  module Parsers
    module Csv
      module Assertions
        class XsdAssertionParser
          def self.parse(header, row, resources)
            value = Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::XSD, row)
            return nil if value.nil?

            xsd = resources[value]
            if xsd.nil? or xsd == ''
              raise ArgumentError 'Invalid Data Format. Value of <Xsd> is not exist in Resources. key=%s' % value
            end

            [ Tatami::Models::Assertions::XsdAssertion.new(:xsd => xsd) ]
          end
        end
      end
    end
  end
end