module Tatami
  module Parsers
    module Documents
      class JsonParser < XmlParser
        attr_accessor :contents, :document
        def initialize(contents)
          @contents = contents

          v = Hash.from_xml %{
            <hash>
              <users type="array">
                  <user type="integer">1</user>
                  <user type="integer">2</user>
                  <user type="integer">3</user>
              </users>
            </hash>
            }
          v2 = v.to_xml # to_xml doesn't work...

          #xml = JSON.parse(@contents).to_xml(:root => :my_root)
          @document = Nokogiri::XML.parse(xml, nil, "UTF-8")
        end
      end
    end
  end
end