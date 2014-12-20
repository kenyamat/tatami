module Tatami
  module Models
    module Assertions
      class AssertionBase
        attr_accessor :expected_value, :actual_value, :success, :exception
      end
    end
  end
end