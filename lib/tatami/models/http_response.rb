module Tatami
  module Models
    class HttpResponse < ModelBase
      include Tatami::Constants::ParserType
      attr_accessor :uri, :status_code, :content_type, :last_modified, :headers, :cookies, :contents, :exception

      def initialize(params = nil)
        super
        @document_parser ||= nil
        @contents ||= nil
      end

      def get_document_parser
        @document_parser = case get_parser_type
                           when XML then Tatami::Parsers::Documents::XmlParser.new(@contents)
                           when HTML then Tatami::Parsers::Documents::HtmlParser.new(@contents)
                           when JAVASCRIPT then @document_parser = Tatami::Parsers::Documents::JsonParser.new(@contents)
                           else Tatami::Parsers::Documents::TextParser.new(@contents)
                           end if @document_parser.nil?
        @document_parser
      end

      def exists_node?(xpath, attribute = nil)
        get_document_parser.exists_node?(xpath, attribute)
      end

      def get_document_value(xpath, attribute = nil)
        get_document_parser.get_document_value(xpath, attribute)
      end

      def get_document_values(xpath, attribute = nil)
        get_document_parser.get_document_values(xpath, attribute)
      end

      def to_s
        "uri=#{uri}, status_code=#{status_code}, last_modified=#{last_modified}, content_type=#{content_type}, headers=#{headers}, cookies=#{cookies}, exception=#{exception}"
      end

      private
      def get_parser_type
        content_type = @content_type.downcase
        return HTML if content_type.include?('html')
        return XML if content_type.include?('xml')
        return JAVASCRIPT if content_type.include?('javascript') or content_type.include?('json')
        TEXT
      end
    end
  end
end