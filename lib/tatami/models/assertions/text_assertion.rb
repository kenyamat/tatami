module Tatami
  module Models
    module Assertions
      class TextAssertion < AssertionBase
        attr_accessor :is_list, :expected, :actual

        def initialize(params = nil)
          super
          @is_list ||= false
          @key ||= nil
        end

        def get_name
          @name
        end

        def match(value, pattern)
          Regexp.new(pattern) =~ value
          return Regexp.last_match[1] unless Regexp.last_match.nil?
          raise Tatami::WrongFileFormatError, 'Regex failed to match: value:%s, pattern:%s' % [ value, pattern ]
        end

        def assert(expected, actual)
          unless @expected.exists.nil?
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
          @expected_value = URI.decode_www_form_component(@expected_value) if @expected.url_decode
          @actual_value = URI.decode_www_form_component(@actual_value) if @actual.url_decode
          @success = @expected_value == @actual_value
        end

        private
        def get_value(arrange, assertion_item)
          return assertion_item.value unless assertion_item.value.nil?
          value = arrange.http_response.get_document_value(assertion_item.query, assertion_item.attribute)
          return match(value, assertion_item.pattern) unless assertion_item.pattern.nil?
          value
        end

        def get_values(arrange, assertion_item)
          raise Tatami::WrongFileFormatError, 'Static value test for list is not supported.' unless assertion_item.value.nil?
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