RSpec.describe Tatami::Models::TestCase do
  let(:sut) { Tatami::Models::TestCase.new(name: 'sut', assertions: assertions) }

  describe '#success?' do
    subject { sut.success? }

    context 'when assertions are all success' do
      let(:assertions) { [double(success?: true), double(success?: true)] }
      it { is_expected.to eq true }
    end

    context 'when assertions is empty' do
      let(:assertions) { [] }
      it { is_expected.to eq true }
    end

    context 'when assertions has a failed assertion' do
      let(:assertions) { [double(success?: true), double(success?: false)] }
      it { is_expected.to eq false }
    end
  end

  describe '#get_failed_assertions' do
    subject { sut.get_failed_assertions }

    context 'when assertions are all success' do
      let(:assertions) { [double(success?: true), double(success?: true)] }
      it { is_expected.to match_array [] }
    end

    context 'when assertions is empty' do
      let(:assertions) { [] }
      it { is_expected.to match_array [] }
    end

    context 'when assertions has a failed assertion' do
      let(:assertions) { [double(success?: true), double(success?: false)] }
      it { is_expected.to be_any }
    end
  end

  describe '#assert' do
    subject { sut.assert(nil, nil) }

    context 'when assertions are all success' do
      let(:assertions) { [double(assert: true, success?: true), double(assert: true, success?: true)] }
      it { is_expected.to be_success }
    end

    context 'when assertions is empty' do
      let(:assertions) { [] }
      it { is_expected.to be_success }
    end

    context 'when assertions has a failed assertion' do
      let(:assertions) { [double(assert: true, success?: true), double(assert: true, success?: false)] }
      it { is_expected.not_to be_success }
    end

    context 'when assertion throws exception' do
      let(:assertion) { Tatami::Models::Assertions::UriAssertion.new }
      let(:assertions) { [ assertion ] }
      it {
        allow(assertion).to receive(:assert).and_raise(ArgumentError)
        sut.assert(nil, nil)
        expect(assertion.success?).to eq false
        expect(assertion.exception). to be_an_instance_of ArgumentError
      }
    end
  end
end