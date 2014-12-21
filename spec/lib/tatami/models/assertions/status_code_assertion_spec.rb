RSpec.describe Tatami::Models::Assertions::StatusCodeAssertion do
  describe '#get_name' do
    let(:sut) { Tatami::Models::Assertions::StatusCodeAssertion.new }
    subject { sut.get_name }
    it { is_expected.to eq 'StatusCode' }
  end

  describe '#assert' do
    let(:sut) { Tatami::Models::Assertions::StatusCodeAssertion.new(value: expected_status_code) }
    let(:http_response) { double('http_response', :status_code => response_status_code) }
    subject { sut.assert(nil, Tatami::Models::Arrange.new(http_response: http_response)) }

    context 'when valid' do
      let(:expected_status_code) { 200 }
      let(:response_status_code) { 200 }
      it { is_expected.to eq true }
    end

    context 'when not valid' do
      let(:expected_status_code) { 404 }
      let(:response_status_code) { 200 }
      it { is_expected.to eq false }
    end
  end
end