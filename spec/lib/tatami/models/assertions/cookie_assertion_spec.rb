RSpec.describe Tatami::Models::Assertions::CookieAssertion do
  let(:sut) { Tatami::Models::Assertions::CookieAssertion.new }
  let(:expected) { Tatami::Models::Arrange.new }
  let(:actual) { Tatami::Models::Arrange.new }

  describe '#get_name' do
    it 'gets name' do
      sut.key = 'name'
      expect(sut.get_name).to eq 'Cookies(name)'
    end
  end

  describe '#assert' do
    before do
      actual.http_response = double('http_response', :cookies => { 'key1' => 'value1', 'key2' => 'value2' })
    end

    it 'succeeds' do
      sut.key = 'key1'
      sut.value = 'value1'
      expect(sut.assert(expected, actual)).to eq true
    end

    it 'fails' do
      sut.key = 'key1'
      sut.value = 'xxxxx'
      expect(sut.assert(expected, actual)).to eq false
    end

    it 'fails as key not found' do
      sut.key = 'xxxxx'
      sut.value = 'value1'
      expect(sut.assert(expected, actual)).to eq false
    end
  end
end