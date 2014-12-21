module Tatami
  module Parsers
    module Documents
      class HtmlParser < XmlParser
        attr_accessor :contents, :document

        def initialize(contents)
          @contents = contents
          @document = Nokogiri::HTML.parse(@contents, nil, 'UTF-8')
        end
      end
    end
  end
end