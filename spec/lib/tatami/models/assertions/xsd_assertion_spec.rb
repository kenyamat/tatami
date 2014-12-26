RSpec.describe Tatami::Models::Assertions::XsdAssertion do
  let(:sut) { Tatami::Models::Assertions::XsdAssertion.new(:xsd => 'xsd') }

  describe '#get_name' do
    subject { sut.get_name }
    it { is_expected.to eq 'Xsd' }
  end

  describe '#assert' do
    let(:test_result) { true }
    let(:parser) { double(:test_schema_with_xsd => test_result) }
    let(:http_response) { double('http_response', :get_document_parser => parser) }
    subject { sut.assert(nil, Tatami::Models::Arrange.new(http_response: http_response)) }

    context 'when valid' do
      it { is_expected.to eq true }
    end

    context 'when not valid' do
      let(:test_result) { false }
      it { is_expected.to eq false }
    end

    context 'when error is thrown from test_schema_with_xsd' do
      it {
        allow(parser).to receive(:test_schema_with_xsd).and_raise(ArgumentError)
        is_expected { subject }.to eq false
      }
    end
  end
end