RSpec.describe Tatami::Models::Assertions::CookieAssertion do
  describe '#get_name' do
    let(:sut) { Tatami::Models::Assertions::CookieAssertion.new(key: 'name') }
    subject { sut.get_name }
    it { is_expected.to eq 'Cookies(name)' }
  end

  describe '#assert' do
    let(:sut) { Tatami::Models::Assertions::CookieAssertion.new(key: expected_key, value: expected_value) }
    let(:http_response) { double('http_response', :cookies => response_cookies) }
    subject { sut.assert(nil, Tatami::Models::Arrange.new(http_response: http_response)) }

    context 'when valid' do
      let(:expected_key) { :key1 }
      let(:expected_value) { 'value1' }
      let(:response_cookies) { { :key1 => 'value1' } }
      it { is_expected.to eq true }
    end

    context 'when not valid' do
      let(:expected_key) { :key1 }
      let(:expected_value) { 'value1' }
      let(:response_cookies) { { :key1 => 'xxx' } }
      it { is_expected.to eq false }
    end

    context 'when key is not found' do
      let(:expected_key) { :key1 }
      let(:expected_value) { 'value1' }
      let(:response_cookies) { {} }
      it { is_expected.to eq false }
    end
  end
end