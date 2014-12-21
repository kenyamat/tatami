RSpec.describe Tatami::Models::Assertions::HeaderAssertion do
  let(:expected) { Tatami::Models::Arrange.new }
  let(:actual) { Tatami::Models::Arrange.new }
  let(:sut) { Tatami::Models::Assertions::HeaderAssertion.new }

  describe '#get_name' do
    it 'gets name' do
      sut.key = 'name'
      expect(sut.get_name).to eq 'Headers(name)'
    end
  end

  describe '#assert' do
    before do
      actual.http_response = double('http_response', :headers => { 'key' => 'value' })
    end

    it 'successes' do
      sut.key = 'key'
      sut.value = 'value'
      expect(sut.assert(expected, actual)).to eq true
    end

    it 'fails' do
      sut.key = 'key'
      sut.value = 'xxxxx'
      expect(sut.assert(expected, actual)).to eq false
    end
  end
end
