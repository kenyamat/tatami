module Tatami
  module Models
    module Assertions
      class ContentAssertionItem < ModelBase
        attr_accessor :key, :value, :query, :attribute, :exists, :pattern, :format, :format_culture, :url_decode
      end
    end
  end
end