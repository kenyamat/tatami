module Tatami
  module Models
    class ModelBase
      def initialize(params = nil)
        (params || []).each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end
    end
  end
end