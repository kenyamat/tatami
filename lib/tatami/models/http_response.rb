module Tatami
  module Models
    class HttpResponse < ModelBase
      attr_accessor :uri, :status_code, :content_type, :last_modified, :headers, :cookies, :contents, :exception

      def initialize(params = nil)
        super
        @document_parser ||= nil
      end

      def get_document_parser
        if @document_parser.nil?
          case get_parser_type
            when Tatami::Constants::ParserType::XML
              @document_parser = Tatami::Parsers::Documents::XmlParser.new(@contents)
            when Tatami::Constants::ParserType::HTML
              @document_parser = Tatami::Parsers::Documents::HtmlParser.new(@contents)
            when Tatami::Constants::ParserType::JAVASCRIPT
              @document_parser = Tatami::Parsers::Documents::JsonParser.new(@contents)
            else
              @document_parser = Tatami::Parsers::Documents::TextParser.new(@contents)
          end
        end
        @document_parser
      end

      def exists_node?(xpath, attribute = nil)
        begin
          get_document_parser.exists_node?(xpath, attribute)
        rescue => ex
          raise ArgumentError, 'Failed to get value from document. ParserType=%s, xpath=%s, attribute=%s, exception=%s, message=%s' %
              [get_parser_type, xpath, attribute, ex.class, ex.message]
        end
      end

      def get_document_value(xpath, attribute = nil)
        begin
          get_document_parser.get_document_value(xpath, attribute)
        rescue => ex
          raise ArgumentError, 'Failed to get value from document. ParserType=%s, xpath=%s, attribute=%s, exception=%s, message=%s' %
              [get_parser_type, xpath, attribute, ex.class, ex.message]
        end
      end

      def get_document_values(xpath, attribute = nil)
        begin
          get_document_parser.get_document_values(xpath, attribute)
        rescue => ex
          raise ArgumentError, 'Failed to get value from document. ParserType=%s, xpath=%s, attribute=%s, exception=%s, message=%s' %
              [get_parser_type, xpath, attribute, ex.class, ex.message]
        end
      end

      private

      def get_parser_type
        content_type = @content_type.downcase
        return Tatami::Constants::ParserType::HTML if content_type.include?('html')
        return Tatami::Constants::ParserType::XML if content_type.include?('xml')
        return Tatami::Constants::ParserType::JAVASCRIPT if content_type.include?('javascript') or content_type.include?('json')
        Tatami::Constants::ParserType::TEXT
      end
    end
  end
end