module Tatami
  module Models
    class TestCases < ModelBase
      attr_accessor :name, :test_cases

      def initialize(params = nil)
        super
        @test_cases ||= []
      end

      def success?
        @test_cases.each { |test_case| return false unless test_case.success? }
        true
      end

      def get_failed_cases
        list = []
        return list if success?
        @test_cases.each { |test_case|
          unless test_case.success?
            list.push(test_case)
          end
        }
        list
      end

      def get_result_message
        buffer = ''
        buffer.force_encoding("UTF-8")
        buffer << "Test Cases Count: %s/%s\n" % [get_failed_cases.length, @test_cases.length]

        @test_cases.each { |test_case|
          buffer << "  Test Case Name: %s\n" % [test_case.name]
          buffer << "    Success: %s\n" % [test_case.success?]
          buffer << "    Arranges\n"
          buffer << "      Expected\n"

          unless test_case.arranges.expected.nil?
            buffer << "        HttRequest: %s\n" % [test_case.arranges.expected.http_request]
            buffer << "        HttResponse: %s\n" % [test_case.arranges.expected.http_response]
          end

          buffer << "      Actual\n"

          unless test_case.arranges.actual.nil?
            buffer << "        HttRequest: %s\n" % [test_case.arranges.actual.http_request]
            buffer << "        HttResponse: %s\n" % [test_case.arranges.actual.http_response]
          end

          buffer << "    Assertions Count: %s/%s\n" % [test_case.get_failed_assertions.length, test_case.assertions.length]

          test_case.assertions.each { |assertion|
            buffer << "      Assertion Name: %s\n" % [assertion.get_name]
            buffer << "        Success: %s\n" % [assertion.success?]

            if assertion.exception
              buffer << "        Result StackTrace: %s\n" % [assertion.exception]
            else
              buffer << "        Result Message: Expected:<%s>. Actual:<%s>.\n" % [assertion.expected_value, assertion.actual_value]
            end
          }
        }
        buffer
      end

      def get_failed_message
        return nil if success?

        buffer = ''
        buffer << "Failed Test Cases Count: %s/%s\n" % [get_failed_cases.length, @test_cases.length]

        get_failed_cases.each { |test_case|
          buffer << "  Failed Test Case Name: %s\n" % [test_case.name]
          buffer << "    Arranges\n"
          buffer << "      Expected\n"

          unless test_case.arranges.expected.nil?
            buffer << "        HttRequest: %s\n" % [test_case.arranges.expected.http_request]
            buffer << "        HttResponse: %s\n" % [test_case.arranges.expected.http_response]
          end

          buffer << "      Actual\n"
          unless test_case.arranges.actual.nil?
            buffer << "        HttRequest: %s\n" % [test_case.arranges.actual.http_request]
            buffer << "        HttResponse: %s\n"% [test_case.arranges.actual.http_response]
          end

          buffer << "    Failed Assertions Count: %s/%s\n" % [test_case.get_failed_assertions.length, test_case.assertions.length]
          test_case.get_failed_assertions.each { |failed_assertion|
            buffer << "      Failed Assertion Name: %s\n" % [failed_assertion.get_name]
            if failed_assertion.exception
              buffer << "        Result StackTrace: %s\n" % [failed_assertion.exception]
            else
              buffer << "        Result Message: Expected:<%s>. Actual:<%s>.\n" % [failed_assertion.expected_value, failed_assertion.actual_value]
            end
          }
        }
        buffer
      end

      def test(http_request_service, http_request_service_for_expected = nil, hook_for_actual = nil, hook_for_expected = nil)
        http_request_service_for_expected ||= http_request_service

        @test_cases.each { |test_case|
          if test_case.arranges.expected and test_case.arranges.expected.http_request
            test_case.arranges.expected.http_response = http_request_service_for_expected.get_response(test_case.arranges.expected.http_request, hook_for_expected)
          end

          if test_case.arranges.actual
            test_case.arranges.actual.http_response = http_request_service.get_response(test_case.arranges.actual.http_request, hook_for_actual)
          end

          test_case.assert(test_case.arranges.expected, test_case.arranges.actual)
        }
        self
      end
    end
  end
end