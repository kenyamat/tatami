RSpec.describe Tatami::Models::Assertions::TextAssertion do
  let(:expected) { Tatami::Models::Assertions::ContentAssertionItem.new(expected_params) }
  let(:sut) {
    Tatami::Models::Assertions::TextAssertion.new(
      name: 'assert1',
      is_list: is_list,
      expected: expected,
      actual: Tatami::Models::Assertions::ContentAssertionItem.new(actual_params))
  }
  let(:expected_params) { {} }
  let(:actual_params) { {} }
  let(:is_list) { false }

  describe '#get_name' do
    subject { sut.get_name }

    context 'when valid' do
      it { is_expected.to eq 'assert1' }
    end
  end

  describe '#match' do
    subject { sut.match(value, ':(.*)') }

    context 'when valid' do
      let(:value) { 'aaa:bbb' }
      it { is_expected.to eq 'bbb' }
    end

    context 'when not valid' do
      let(:value) { 'aaa' }
      it { expect { subject }.to raise_error(ArgumentError, /Regex failed to match:/) }
    end
  end

  describe '#assert' do
    context 'exists' do
      let(:expected_params) { { :exists => true } }

      subject { sut.assert(Tatami::Models::Arrange.new,
                           Tatami::Models::Arrange.new(http_response: double(:exists_node? => response_exists))) }

      context 'when exist' do
        let(:response_exists) { true }
        it { is_expected.to eq true }
      end

      context 'when not exist' do
        let(:response_exists) { false }
        it { is_expected.to eq false }
      end
    end

    context 'single value' do
      subject { sut.assert(Tatami::Models::Arrange.new(http_response: double(:get_document_value => expected_value)),
                           Tatami::Models::Arrange.new(http_response: double(:get_document_value => actual_value))) }

      context 'when valid' do
        let(:expected_value) { 'a' }
        let(:actual_value) { 'a' }
        it { is_expected.to eq true }
      end

      context 'when not valid' do
        let(:expected_value) { 'a' }
        let(:actual_value) { 'b' }
        it { is_expected.to eq false }
      end

      context 'when url-decode' do
        let(:actual_params) { { :url_decode => true } }
        let(:expected_value) { 'a b' }
        let(:actual_value) { 'a%20b' }
        it { is_expected.to eq true }
      end

      context 'when regex' do
        let(:actual_params) { { :pattern => ':(.*)' } }
        let(:expected_value) { 'ab' }
        let(:actual_value) { 'cc:ab' }
        it { is_expected.to eq true }
      end
    end

    context 'list' do
      let(:is_list) { true }
      let(:static_value) { nil }
      subject { sut.assert(Tatami::Models::Arrange.new(http_response: double(:get_document_values => expected_value)),
                           Tatami::Models::Arrange.new(http_response: double(:get_document_values => actual_value))) }

      context 'when valid' do
        let(:expected_value) { %w(a b) }
        let(:actual_value) { %w(a b) }
        it { is_expected.to eq true }
      end

      context 'when not valid' do
        let(:expected_value) { %w(a b) }
        let(:actual_value) { %w(a c) }
        it { is_expected.to eq false }
      end

      context 'when static value' do
        let(:expected_value) { %w(a b) }
        let(:actual_value) { %w(a b) }
        it {
          allow(expected).to receive(:value) { 'vvvv' }
          expect { subject }.to raise_error(ArgumentError, /Static value test/)
        }
      end

      context 'when regex' do
        let(:expected_value) { %w(a b) }
        let(:actual_value) { %w(cc:a cc:b) }
        let(:actual_params) { { :pattern => ':(.*)' } }
        it { is_expected.to eq true }
      end
    end
  end
end