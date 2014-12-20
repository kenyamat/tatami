module Tatami
  module Models
    module Assertions
      class DateTimeAssertion < TextAssertion
        attr_accessor :is_time

        def assert(expected, actual)
          if @is_list
            @expected_value = get_values(expected, @expected).join(', ')
            @actual_value = get_values(actual, @actual).join(', ')
          else
            @expected_value = get_value(expected, @expected)
            @actual_value = get_value(actual, @actual)
          end

          @success = @expected_value == @actual_value
        end

        def get_value(arrange, assertion_item)
          value = super(arrange, assertion_item)
          get_datetime_string(value, assertion_item.format)
        end

        def get_values(arrange, assertion_item)
          values = super(arrange, assertion_item)
          list = []
          values.each { |value|
            list.push(get_datetime_string(value, assertion_item.format))
          }

          list
        end

        def get_datetime_string(value, format)
          begin
            if is_time
              return Time.strptime(value, format).strftime('%H%M%S')
            end

            Date.strptime(value, format).strftime('%Y%m%d%H%M%S')
          rescue => ex
            ex.message << ' Failed to parse DateTime. value=%s, format=%s, IsTime=%s' % [ value, format, @is_time ]
            raise ex
          end
        end
      end
    end
  end
end