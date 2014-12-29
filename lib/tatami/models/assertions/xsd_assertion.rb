module Tatami
  module Models
    module Assertions
      class XsdAssertion < AssertionBase
        attr_accessor :xsd

        def get_name
          Tatami::Constants::HeaderNames::XSD
        end

        def assert(expected, actual)
          begin
            result = actual.http_response.get_document_parser.test_schema_with_xsd(@xsd)
          rescue => ex
            result = false
            text = ex.to_s
          end
          @expected_value = 'True'
          @actual_value = result ? 'True' : 'Exception=<%s>' % text
          @success = @expected_value == @actual_value
        end
      end
    end
  end
end