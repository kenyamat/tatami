module Tatami
  module Parsers
    module Csv
      module Assertions
        class UriAssertionParser
          include Tatami::Constants::HeaderNames

          def self.parse(header, row)
            value = Tatami::Models::Csv::Header.get_string(header, URI, row)
            return nil if value.nil?
            raise Tatami::WrongFileFormatError, 'Invalid Data Format. Value of <Uri> does not start with \'/\'. value=%s' % value unless value.start_with?('/')
            [ Tatami::Models::Assertions::UriAssertion.new(:value => value) ]
          end
        end
      end
    end
  end
end