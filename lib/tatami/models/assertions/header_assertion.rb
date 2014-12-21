module Tatami
  module Models
    module Assertions
      class HeaderAssertion < AssertionBase
        attr_accessor :key, :value

        def get_name
          '%s(%s)' % [ Tatami::Constants::HeaderNames::HEADERS, @key ]
        end

        def assert(expected, actual)
          @expected_value = @value
          @actual_value = actual.http_response.headers[@key]
          @success = @expected_value == @actual_value
        end
      end
    end
  end
end