RSpec.describe Tatami::Parsers::Documents::JsonParser do

  let(:contents) { '{ "html" : { "body" : { "div" : { "text" : "hello world", "class" : "warn" } } } }' }
  let(:sut) { Tatami::Parsers::Documents::JsonParser.new(contents) }

  describe '#exists_node' do

    it 'returns true when a node exists' do
      result = sut.exists_node('/Root/html/body/div')
      expect(result).to eq true
    end

    it 'returns false when a node does not exist' do
      result = sut.exists_node('/Root/html/body/a')
      expect(result).to eq false
    end

  end

  describe '#get_document_value' do

    it 'returns node value' do
      result = sut.get_document_value('/Root/html/body/div/text')
      expect(result).to eq 'hello world'
    end

    it 'raises a exception when a node does not exist' do
      expect{ sut.get_document_value('/Root/html/body/a') }.to raise_error
    end
  end
end