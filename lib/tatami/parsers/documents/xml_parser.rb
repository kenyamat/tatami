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
          return false if html_node.nil?
          if attribute.to_s.strip != ''
            attribute_node = html_node.attribute(attribute)
            return false if attribute_node.nil?
          end
          true
        end

        def get_document_value(xpath, attribute = nil)
          html_node = @document.at_xpath(xpath)
          raise ArgumentError, 'node not found. xpath=%s, attribute=%s' % [xpath, attribute] if html_node.nil?
          if attribute.to_s.strip == ''
            html_node.text
          else
            raise ArgumentError, 'attribute not found. xpath=%s, attribute=%s' % [xpath, attribute] if html_node.attribute(attribute).nil?
            html_node.attribute(attribute).value
          end
        end

        def get_document_values(xpath, attribute = nil)
          list = []
          html_nodes = @document.xpath(xpath)
          raise ArgumentError, 'node not found. xpath=%s, attribute=%s' % [xpath, attribute] if html_nodes.nil?
          html_nodes.each do |html_node|
            if attribute.to_s.strip == ''
              value = html_node.text
            else
              raise ArgumentError, 'attribute not found. xpath=%s, attribute=%s' % [xpath, attribute] if html_node.attribute(attribute).nil?
              value = html_node.attribute(attribute).value
            end

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