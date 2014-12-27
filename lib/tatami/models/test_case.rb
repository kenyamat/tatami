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
        return list if success?
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
          rescue => ex
            assertion.exception = ex
            assertion.success = false
          end
        }
        self
      end
    end
  end
end