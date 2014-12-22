module Tatami
  module Parsers
    module Documents
      class XmlParser
        attr_accessor :contents, :document
        def initialize(contents)
          @contents = contents
          @document = Nokogiri::XML.parse(@contents, nil, 'UTF-8')
        end

        def exists_node?(xpath, attribute = nil)
          html_node = @document.at_xpath(xpath)
          if html_node.nil?
            return false
          end

          if !attribute.nil? and !attribute.empty?
            attribute_node = html_node.attribute(attribute)
            if attribute_node.nil?
              return false
            end
          end
          true
        end

        def get_document_value(xpath, attribute = nil)
          html_node = @document.at_xpath(xpath)

          if attribute.nil? or attribute.empty?
            html_node.text
          else
            html_node.attribute(attribute).value
          end
        end

        def get_document_values(xpath, attribute = nil)
          list = []
          html_nodes = @document.xpath(xpath)

          html_nodes.each do |html_node|
            value = (attribute.nil? or attribute.empty?) ? html_node.text : html_node.attribute(attribute).value
            list.push(value)
          end
          list
        end

        def test_schema_with_xsd(xsd)
          schema = Nokogiri::XML::Schema(xsd)
          schema.validate(@document).length == 0
        end
      end
    end
  end
end