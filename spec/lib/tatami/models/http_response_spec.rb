RSpec.describe Tatami::Models::HttpResponse do
  let(:sut) { Tatami::Models::HttpResponse.new(content_type: content_type, contents: contents) }

  describe '#get_document_parser' do
    subject { sut.get_document_parser }

    context 'XmlParser' do
      let(:content_type) { 'text/xml' }
      let(:contents) { '<root><body>a</body></root>' }
      it { is_expected.to be_a_kind_of Tatami::Parsers::Documents::XmlParser }
    end

    context 'HtmlParser' do
      let(:content_type) { 'text/html' }
      let(:contents) { '<html><body>a</body></html>' }
      it { is_expected.to be_a_kind_of Tatami::Parsers::Documents::HtmlParser }
    end

    context 'JsonParser' do
      let(:content_type) { 'text/javascript' }
      let(:contents) { '{ "name" : "Tom" }' }
      it { is_expected.to be_a_kind_of Tatami::Parsers::Documents::JsonParser }
    end

    context 'TextParser' do
      let(:content_type) { 'text/plain' }
      let(:contents) { 'aaa' }
      it { is_expected.to be_a_kind_of Tatami::Parsers::Documents::TextParser }
    end

  end

  context 'test tree' do
    let(:content_type) { 'text/xml' }
    let(:contents) { '<root><body>a</body></root>' }
    let(:xpath) { '/root/body' }

    describe '#exists_node?' do
      subject { sut.exists_node?(xpath) }

      context 'when exist' do
        it { is_expected.to eq true }
      end

      context 'when invalid xpath' do
        let(:xpath) { '\\' }
        it { expect { subject }.to raise_error }
      end
    end

    describe '#get_document_value' do
      subject { sut.get_document_value(xpath) }

      context 'when valid' do
        it { is_expected.to eq 'a' }
      end

      context 'when invalid xpath' do
        let(:xpath) { '\\' }
        it { expect { subject }.to raise_error }
      end
    end

    describe '#get_document_values' do
      subject { sut.get_document_values(xpath) }

      context 'when valid' do
        it { is_expected.to eq ['a'] }
      end

      context 'when invalid xpath' do
        let(:xpath) { '\\' }
        it { expect { subject }.to raise_error }
      end
    end

    describe '#to_s' do
      let(:sut) { Tatami::Models::HttpResponse.new(
          uri: 'uri',
          status_code: 'status_code',
          content_type: 'content_type',
          last_modified: 'last_modified',
          headers: 'headers',
          cookies: 'cookies',
          contents: 'contents',
          exception: 'exception'
      ) }
      subject { sut.to_s }
      it { is_expected.to eq 'uri=uri, status_code=status_code, last_modified=last_modified, content_type=content_type, headers=headers, cookies=cookies, exception=exception' }
    end
  end
end