module Tatami
  module Models
    module Assertions
      class StatusCodeAssertion < AssertionBase
        attr_accessor :value

        def initialize(params = nil)
          (params || []).each do |key, value|
            instance_variable_set("@#{key}", value)
          end
        end

        def get_name
          Tatami::Constants::HeaderNames::STATUS_CODE
        end

        def assert(expected, actual)
          @expected_value = @value
          @actual_value = actual.http_response.status_code.to_s
          @success = @expected_value == @actual_value
        end
      end
    end
  end
end