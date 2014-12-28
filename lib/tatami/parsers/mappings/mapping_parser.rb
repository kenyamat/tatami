module Tatami
  module Parsers
    module Mappings
      class MappingParser
        def self.parse(file_path)
          mapping_xml = File.read(file_path, :encoding => Encoding::UTF_8)
          mapping = {}
          Nokogiri::XML(mapping_xml).xpath('//Item').each { |item| mapping[item.attribute('Key').to_s] = item.text.to_s }
          mapping
        end
      end
    end
  end
end