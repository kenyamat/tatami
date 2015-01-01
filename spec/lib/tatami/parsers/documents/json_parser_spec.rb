RSpec.describe Tatami::Parsers::Documents::JsonParser do
  let(:sut) { Tatami::Parsers::Documents::JsonParser.new(contents) }
  let(:contents) { '{ "html" : { "body" : { "div" : { "text" : "hello world", "class" : "warn" } } } }' }

  describe '#exists_node?' do
    subject { sut.exists_node?(xpath) }

    context 'when node is found' do
      let(:xpath) { '/Root/html/body/div' }
      it { is_expected.to eq true }
    end

    context 'when node is not found' do
      let(:xpath) { '/Root/html/body/a' }
      it { is_expected.to eq false }
    end
  end

  describe '#get_document_value' do
    subject { sut.get_document_value(xpath) }

    context 'when node is found' do
      let(:xpath) { '/Root/html/body/div/text' }
      it { is_expected.to eq 'hello world' }
    end

    context 'when node is not found' do
      let(:xpath) { '/Root/html/body/div/a' }
      it { expect { subject }.to raise_error(Tatami::WrongFileFormatError, /node not found./) }
    end
  end
end