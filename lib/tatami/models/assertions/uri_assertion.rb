module Tatami
  module Models
    module Assertions
      class UriAssertion < AssertionBase
        attr_accessor :value

        def get_name
          Tatami::Constants::HeaderNames::URI
        end

        def assert(expected, actual)
          @expected_value = @value
          md = actual.http_response.uri.match('.*://[^/]*(.*)')
          if md
            @actual_value = md[1]
            @actual_value = '/' if @actual_value.to_s.strip == ''
          end
          @success = @expected_value == @actual_value
        end
      end
    end
  end
end