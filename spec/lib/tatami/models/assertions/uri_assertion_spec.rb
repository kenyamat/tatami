RSpec.describe Tatami::Models::Assertions::UriAssertion do
  describe '#get_name' do
    let(:sut) { Tatami::Models::Assertions::UriAssertion.new }
    subject { sut.get_name }
    it { is_expected.to eq 'Uri' }
  end

  describe '#assert' do
    let(:sut) { Tatami::Models::Assertions::UriAssertion.new(value: expected_uri) }
    let(:http_response) { double('http_response', :uri => response_uri) }
    subject { sut.assert(nil, Tatami::Models::Arrange.new(http_response: http_response)) }

    context 'when valid' do
      context 'path infos' do
        let(:expected_uri) { '/test/test1' }
        let(:response_uri) { 'http://a.com/test/test1' }
        it { is_expected.to eq true }
      end

      context 'query strings' do
        let(:expected_uri) { '/test?a=b' }
        let(:response_uri) { 'http://a.com/test?a=b' }
        it { is_expected.to eq true }
      end

      context 'fragment' do
        let(:expected_uri) { '/test#aaa' }
        let(:response_uri) { 'http://a.com/test#aaa' }
        it { is_expected.to eq true }
      end

      context 'root with slash' do
        let(:expected_uri) { '/' }
        let(:response_uri) { 'http://a.com/' }
        it { is_expected.to eq true }
      end

      context 'root with no slash' do
        let(:expected_uri) { '/' }
        let(:response_uri) { 'http://a.com' }
        it { is_expected.to eq true }
      end
    end

    context 'when not valid' do
      context 'when not match' do
        let(:expected_uri) { '/test' }
        let(:response_uri) { 'http://a.com/xxx' }
        it { is_expected.to eq false }
      end
    end
  end
end