RSpec.describe Tatami::Models::Assertions::StatusCodeAssertion do
  let(:expected) { Tatami::Models::Arrange.new }
  let(:actual) { Tatami::Models::Arrange.new }
  let(:sut) { Tatami::Models::Assertions::StatusCodeAssertion.new(value: value) }
  let(:value) { 200 }

  describe '#get_name' do
    it 'gets name' do
      expect(sut.get_name).to eq 'StatusCode'
    end
  end

  describe '#assert' do
    before { actual.http_response = double('http_response', :status_code => 200) }
    subject { sut.assert(expected, actual) }

    it 'successes' do
      sut.value = '200'
      is_expected.to eq true
    end

    it 'fails' do
      sut.value = '404'
      is_expected.to eq false
    end
  end
end