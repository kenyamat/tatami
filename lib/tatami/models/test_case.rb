module Tatami
  module Models
    class TestCase < ModelBase
      attr_accessor :name, :arranges, :assertions

      def success?
        @assertions.each { |assertion|
          unless assertion.success?
            return false
          end
        }
        true
      end

      def get_failed_assertions
        list = []
        if success?
          return list
        end

        @assertions.each { |assertion|
          unless assertion.success?
            list.push(assertion)
          end
        }
        list
      end

      def assert(expected, actual)
        @assertions.each { |assertion|
          begin
            assertion.assert(expected, actual)
          rescue ex
            assertion.exception = exception
            assertion.success = false
          end
        }
        self
      end
    end
  end
end