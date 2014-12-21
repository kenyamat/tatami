RSpec.describe Tatami::Models::Assertions::HeaderAssertion do
  describe '#get_name' do
    let(:sut) { Tatami::Models::Assertions::HeaderAssertion.new(key: 'name') }
    subject { sut.get_name }
    it { is_expected.to eq 'Headers(name)' }
  end

  describe '#assert' do
    let(:sut) { Tatami::Models::Assertions::HeaderAssertion.new(key: expected_key, value: expected_value) }
    let(:http_response) { double('http_response', :headers => response_headers) }
    subject { sut.assert(nil, Tatami::Models::Arrange.new(http_response: http_response)) }

    context 'when valid' do
      let(:expected_key) { :'content-type' }
      let(:expected_value) { 'text/plain' }
      let(:response_headers) { { :'content-type' => 'text/plain' } }
      it { is_expected.to eq true }
    end

    context 'when not valid' do
      let(:expected_key) { :'content-type' }
      let(:expected_value) { 'text/plain' }
      let(:response_headers) { { :'content-type' => 'text/xml' } }
      it { is_expected.to eq false }
    end

    context 'when key is not found' do
      let(:expected_key) { :'content-type' }
      let(:expected_value) { 'text/plain' }
      let(:response_headers) { {} }
      it { is_expected.to eq false }
    end
  end
end
