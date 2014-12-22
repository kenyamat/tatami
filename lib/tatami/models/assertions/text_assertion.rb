module Tatami
  module Models
    module Assertions
      class TextAssertion < AssertionBase
        attr_accessor :is_list, :expected, :actual

        def initialize(params = nil)
          super
          @is_list ||= false
        end

        def get_name
          '%s(%s)' % [ Tatami::Constants::HeaderNames::COOKIES, @key ]
        end

        def match(value, pattern)
          Regexp.new(pattern) =~ value
          unless Regexp.last_match.nil?
            return Regexp.last_match[1]
          end

          raise ArgumentError, 'Regex failed to match: value:%s, pattern:%s' % [ value, pattern ]
        end

        def assert(expected, actual)
          if @expected.exists
            @expected_value = 'Node exists: %s' % @expected.exists
            @actual_value = 'Node exists: %s' % actual.http_response.exists_node?(@actual.query, @actual.attribute)
          else
            if @is_list
              @expected_value = get_values(expected, @expected).join(', ')
              @actual_value = get_values(actual, @actual).join(', ')
            else
              @expected_value = get_value(expected, @expected)
              @actual_value = get_value(actual, @actual)
            end
          end

          if @expected.url_decode
            @expected_value = URI.decode_www_form_component(@expected_value)
          end

          if @actual.url_decode
            @actual_value = URI.decode_www_form_component(@actual_value)
          end

          @success = @expected_value == @actual_value
        end

        def get_value(arrange, assertion_item)
          unless assertion_item.value.nil?
            return assertion_item.value
          end

          value = arrange.http_response.get_document_value(assertion_item.query, assertion_item.attribute)
          unless assertion_item.pattern.nil?
            return match(value, assertion_item.pattern)
          end

          value
        end

        def get_values(arrange, assertion_item)
          unless assertion_item.value.nil?
            raise ArgumentError 'Static value test for list is not supported.'
          end

          values = arrange.http_response.get_document_values(assertion_item.query, assertion_item.attribute)
          unless assertion_item.pattern.nil?
            list = []
            values.each {|value|
              list.push(match(value, assertion_item.pattern))
            }

            return list
          end

          values
        end
      end
    end
  end
end