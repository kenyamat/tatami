module Tatami
  module Parsers
    module Csv
      module Assertions
        class UriAssertionParser
          def self.parse(header, row)
            value = Tatami::Models::Csv::Header.get_string(header, Tatami::Constants::HeaderNames::URI, row)
            return nil if value.nil?

            unless value.start_with?('/')
              raise ArgumentError 'Invalid Data Format. Value of <Uri> does not start with \'/\'. value=%s' % value
            end

            [ Tatami::Models::Assertions::UriAssertion.new(:value => value) ]
          end
        end
      end
    end
  end
end