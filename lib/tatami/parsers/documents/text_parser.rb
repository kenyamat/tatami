module Tatami
  module Parsers
    module Documents
      class TextParser
        attr_accessor :contents

        def initialize(contents)
          @contents = contents
        end

        def get_document_value(xpath = nil, attribute = nil)
          @contents
        end
      end
    end
  end
end