RSpec.describe Tatami::Models::HttpResponse do

  let(:sut) { Tatami::Models::HttpResponse.new }

  describe '#get_document_parser' do

    it 'returns a XmlParser' do
      sut.content_type = 'text/xml'
      sut.contents = '<root><body>a</body></root>'
      expect(sut.get_document_parser).to be_a_kind_of Tatami::Parsers::Documents::XmlParser
    end

    it 'returns a HtmlParser' do
      sut.content_type = 'text/html'
      sut.contents = '<html><body>a</body></html>'
      expect(sut.get_document_parser).to be_a_kind_of Tatami::Parsers::Documents::HtmlParser
    end

    it 'returns a JsonParser' do
      sut.content_type = 'text/javascript'
      sut.contents = '{ "name" : "Tom" }'
      expect(sut.get_document_parser).to be_a_kind_of Tatami::Parsers::Documents::JsonParser
    end

    it 'returns a TextParser' do
      sut.content_type = 'text/plain'
      sut.contents = 'aaa'
      expect(sut.get_document_parser).to be_a_kind_of Tatami::Parsers::Documents::TextParser
    end

  end

  describe "#exists_node" do

    it 'returns true' do
      sut.content_type = 'text/xml'
      sut.contents = '<root><body>a</body></root>'
      expect(sut.exists_node('/root/body')).to eq true
    end

    it 'raises a error' do
      sut.content_type = 'text/xml'
      sut.contents = '<root><body>a</body></root>'
      expect{ sut.exists_node('\\') }.to raise_error
    end

  end

  describe "#get_document_value" do

    it 'returns node value' do
      sut.content_type = 'text/xml'
      sut.contents = '<root><body>a</body></root>'
      expect(sut.get_document_value('/root/body')).to eq 'a'
    end

    it 'raises a error' do
      sut.content_type = 'text/xml'
      sut.contents = '<root><body>a</body></root>'
      expect{ sut.get_document_value('\\') }.to raise_error
    end

  end

  describe "#get_document_values" do

    it 'returns node value' do
      sut.content_type = 'text/xml'
      sut.contents = '<root><body>a</body></root>'
      expect(sut.get_document_values('/root/body')).to eq ['a']
    end

    it 'raises a error' do
      sut.content_type = 'text/xml'
      sut.contents = '<root><body>a</body></root>'
      expect{ sut.get_document_values('\\') }.to raise_error
    end

  end

end