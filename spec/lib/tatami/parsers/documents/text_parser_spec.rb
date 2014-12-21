RSpec.describe Tatami::Parsers::Documents::TextParser do
  let(:contents) { 'abc' }
  let(:sut) { Tatami::Parsers::Documents::TextParser.new(contents) }

  describe '#get_document_value' do
    subject { sut.get_document_value }

    context 'when includes text' do
      it { is_expected.to eq 'abc' }
    end
  end
end