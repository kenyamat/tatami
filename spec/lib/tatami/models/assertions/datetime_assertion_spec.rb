RSpec.describe Tatami::Models::Assertions::DateTimeAssertion do
  let(:sut) {
    Tatami::Models::Assertions::DateTimeAssertion.new(is_list: is_list, is_time: is_time,
      expected: Tatami::Models::Assertions::ContentAssertionItem.new(format: date_format),
      actual: Tatami::Models::Assertions::ContentAssertionItem.new(format: date_format))
  }
  let(:date_format) { '%Y-%m-%d' }
  let(:is_list) { false }
  let(:is_time) { false }

  describe '#assert' do
    subject { sut.assert(Tatami::Models::Arrange.new(http_response: expected_response), Tatami::Models::Arrange.new(http_response: actual_response)) }

    context 'single value' do
      let(:expected_response) { double(:get_document_value => expected_value) }
      let(:actual_response) { double(:get_document_value => actual_value) }

      context 'date' do
        context 'when valid' do
          let(:expected_value) { '2014-12-20' }
          let(:actual_value) { '2014-12-20' }
          it { is_expected.to eq true }
        end

        context 'when not valid' do
          let(:expected_value) { '2014-12-20' }
          let(:actual_value) { '2014-12-21' }
          it { is_expected.to eq false }
        end

        context 'when invalid format' do
          let(:expected_value) { '20141220' }
          let(:actual_value) { '20141221' }
          it { expect { subject }.to raise_error(Tatami::WrongFileFormatError, /Failed to parse DateTime/) }
        end
      end

      context 'time' do
        let(:is_time) { true }
        let(:date_format) { '%H:%M:%S' }

        context 'when valid' do
          let(:expected_value) { '23:50:10' }
          let(:actual_value) { '23:50:10' }
          it { is_expected.to eq true }
        end

        context 'when not valid' do
          let(:expected_value) { '23:50:10' }
          let(:actual_value) { '23:50:11' }
          it { is_expected.to eq false }
        end
      end
    end

    context 'list' do
      let(:is_list) { true }
      let(:expected_response) { double(:get_document_values => expected_value) }
      let(:actual_response) { double(:get_document_values => actual_value) }

      context 'date' do
        let(:expected_response) { double(:get_document_values => expected_value) }
        let(:actual_response) { double(:get_document_values => actual_value) }
        let(:is_list) { true }

        context 'when valid' do
          let(:expected_value) { %w(2014-12-20 2014-12-21) }
          let(:actual_value) { %w(2014-12-20 2014-12-21) }
          it { is_expected.to eq true }
        end

        context 'when not valid' do
          let(:expected_value) { %w(2014-12-20 2014-12-21) }
          let(:actual_value) { %w(2014-12-21 2014-12-22) }
          it { is_expected.to eq false }
        end
      end

      context 'time' do
        let(:is_time) { true }
        let(:date_format) { '%H:%M:%S' }

        context 'when valid' do
          let(:expected_value) { %w(23:50:10 23:50:11) }
          let(:actual_value) { %w(23:50:10 23:50:11) }
          it { is_expected.to eq true }
        end

        context 'when not valid' do
          let(:expected_value) { %w(23:50:10 23:50:11) }
          let(:actual_value) { %w(23:50:11 23:50:12) }
          it { is_expected.to eq false }
        end
      end
    end
  end
end