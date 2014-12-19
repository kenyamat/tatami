module Tatami
  module Models
    class HttpResponse
      attr_accessor :uri, :status_code, :content_type, :last_modified, :headers, :cookies, :contents, :exception

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

      def exists_node(xpath, attribute = nil)
        begin
          get_document_parser.exists_node(xpath, attribute)
        rescue => ex
          ex.message << ' : Failed to get value from document. ParserType=%s, xpath=%s, attribute=%s' % [get_parser_type, xpath, attribute]
          raise ex
        end
      end

      def get_document_value(xpath, attribute = nil)
        begin
          get_document_parser.get_document_value(xpath, attribute)
        rescue => ex
          ex.message << ' : Failed to get value from document. ParserType=%s, xpath=%s, attribute=%s' % [get_parser_type, xpath, attribute]
          raise ex
        end
      end

      def get_document_values(xpath, attribute = nil)
        begin
          get_document_parser.get_document_values(xpath, attribute)
        rescue => ex
          ex.message << ' : Failed to get values from document. ParserType=%s, xpath=%s, attribute=%s' % [get_parser_type, xpath, attribute]
          raise ex
        end
      end

      private

      def get_parser_type
        content_type = @content_type.downcase

        if content_type.include?('html')
          return Tatami::Constants::ParserType::HTML
        end

        if content_type.include?('xml')
          return Tatami::Constants::ParserType::XML
        end

        if content_type.include?('javascript') or content_type.include?('json')
          return Tatami::Constants::ParserType::JAVASCRIPT
        end

        Tatami::Constants::ParserType::TEXT
      end

    end
  end
end