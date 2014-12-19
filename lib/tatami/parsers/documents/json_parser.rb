module Tatami
  module Parsers
    module Documents
      class JsonParser < XmlParser
        def initialize(contents)
          @contents = contents
          xml = JSON.parse(@contents).to_xml(:root => Tatami::Constants::HeaderNames::ROOT)
          @document = Nokogiri::XML.parse(xml, nil, 'UTF-8')
        end
      end
    end
  end
end