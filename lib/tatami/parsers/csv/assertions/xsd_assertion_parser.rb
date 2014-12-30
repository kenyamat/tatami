module Tatami
  module Parsers
    module Csv
      module Assertions
        class XsdAssertionParser
          include Tatami::Constants::HeaderNames

          def self.parse(header, row, resources)
            value = Tatami::Models::Csv::Header.get_string(header, XSD, row)
            return nil if value.nil?
            xsd = resources[value]
            raise Tatami::Parsers::WrongFileFormatError, 'Invalid Data Format. Value of <Xsd> is not exist in Resources. key=%s' % value if xsd.to_s.strip == ''
            [ Tatami::Models::Assertions::XsdAssertion.new(:xsd => xsd) ]
          end
        end
      end
    end
  end
end