module Tatami
  module Models
    module Assertions
      class AssertionBase < ModelBase
        attr_accessor :name, :expected_value, :actual_value, :success, :exception

        def success?
          @success
        end
      end
    end
  end
end