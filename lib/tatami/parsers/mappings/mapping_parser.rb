module Tatami
  module Parsers
    module Mappings
      class MappingParser
        def self.parse(xml)
          mapping = {}
          Nokogiri::XML(xml).xpath('//Item').each { |item| mapping[item.attribute('Key').to_s] = item.text.to_s }
          mapping
        end
      end
    end
  end
end