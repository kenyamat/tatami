RSpec.describe Tatami::Parsers::Documents::TextParser do

  let(:contents) { 'abc' }
  let(:sut) { Tatami::Parsers::Documents::TextParser.new(contents) }

  describe '#get_document_value' do

    it 'returns node value' do
      result = sut.get_document_value(nil)
      expect(result).to eq 'abc'
    end

  end
end