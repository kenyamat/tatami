RSpec.describe Tatami::Models::TestCases do
  let(:sut) { Tatami::Models::TestCases.new(name: 'sut', test_cases: test_cases) }

  describe '#success?' do
    subject { sut.success? }

    context 'when test cases are all success' do
      let(:test_cases) { [double(success?: true), double(success?: true)] }
      it { is_expected.to eq true }
    end

    context 'when test cases is empty' do
      let(:test_cases) { [] }
      it { is_expected.to eq true }
    end

    context 'when test cases has a failed assertion' do
      let(:test_cases) { [double(success?: true), double(success?: false)] }
      it { is_expected.to eq false }
    end
  end

  describe '#get_failed_cases' do
    subject { sut.get_failed_cases }

    context 'when test cases are all success' do
      let(:test_cases) { [double(success?: true), double(success?: true)] }
      it { is_expected.to match_array [] }
    end

    context 'when test cases is empty' do
      let(:test_cases) { [] }
      it { is_expected.to match_array [] }
    end

    context 'when test cases has a failed assertion' do
      let(:test_cases) { [double(success?: true), double(success?: false)] }
      it { is_expected.to be_any }
    end
  end

  describe '#test' do
    let(:arrange) { Tatami::Models::Arrange.new(:http_request => {}) }
    let(:test_cases) { [double(:arranges => double(:expected => arrange, :actual => arrange), :assert => {}, :success? => true)] }
    let(:http_request_service) { double('444', :get_response => {}) }

    subject { sut.test(http_request_service) }

    context 'when test cases are all success' do
      it { is_expected.to be_success }
    end

    context 'when test cases are empty' do
      let(:test_cases) { [] }
      it { is_expected.to be_success }
    end

    context 'when test cases have a failed assertion' do
      let(:test_cases) { [double(:arranges => double(:expected => arrange, :actual => arrange), :assert => {}, :success? => false)] }
      it { is_expected.not_to be_success }
    end
  end

  describe '#get_result_message' do
    subject { sut.get_result_message }

    context 'when test cases are all success' do
      let(:test_cases) { [
          Tatami::Models::TestCase.new(
              :name => 'case1',
              :arranges => Tatami::Models::Arranges.new(
                  :name => 'arranges1',
                  :expected => Tatami::Models::Arrange.new,
                  :actual => Tatami::Models::Arrange.new),
              :assertions => [
                  Tatami::Models::Assertions::StatusCodeAssertion.new(:name => 'assertion1', :success => true),
                  Tatami::Models::Assertions::StatusCodeAssertion.new(:name => 'assertion2', :success => true)
              ])
      ]}
      it { is_expected.not_to eq nil }
    end

    context 'when test cases are empty' do
      let(:test_cases) { [] }
      it { is_expected.not_to eq nil }
    end

    context 'when test cases have a failed assertion' do
      let(:test_cases) { [
          Tatami::Models::TestCase.new(
              :name => 'case1',
              :arranges => Tatami::Models::Arranges.new(
                  :name => 'arranges1',
                  :expected => Tatami::Models::Arrange.new,
                  :actual => Tatami::Models::Arrange.new),
              :assertions => [
                  Tatami::Models::Assertions::StatusCodeAssertion.new(:name => 'assertion1', :success => true),
                  Tatami::Models::Assertions::StatusCodeAssertion.new(:name => 'assertion2', :success => false, :exception => SyntaxError.new)
              ])
      ]}
      it { is_expected.not_to eq nil }
    end
  end

  describe '#get_failed_message' do
    subject { sut.get_failed_message }

    context 'when test cases are all success' do
      let(:test_cases) { [
          Tatami::Models::TestCase.new(
              :name => 'case1',
              :arranges => Tatami::Models::Arranges.new(
                  :name => 'arranges1',
                  :expected => Tatami::Models::Arrange.new,
                  :actual => Tatami::Models::Arrange.new),
              :assertions => [
                  Tatami::Models::Assertions::StatusCodeAssertion.new(:name => 'assertion1', :success => true),
                  Tatami::Models::Assertions::StatusCodeAssertion.new(:name => 'assertion2', :success => true)
              ])
      ]}
      it { is_expected.to eq nil }
    end

    context 'when test cases are empty' do
      let(:test_cases) { [] }
      it { is_expected.to eq nil }
    end

    context 'when test cases have a failed assertion' do
      let(:test_cases) { [
          Tatami::Models::TestCase.new(
              :name => 'case1',
              :arranges => Tatami::Models::Arranges.new(
                  :name => 'arranges1',
                  :expected => Tatami::Models::Arrange.new,
                  :actual => Tatami::Models::Arrange.new),
              :assertions => [
                  Tatami::Models::Assertions::StatusCodeAssertion.new(:name => 'assertion1', :success => true),
                  Tatami::Models::Assertions::StatusCodeAssertion.new(:name => 'assertion2', :success => false,),
                  Tatami::Models::Assertions::StatusCodeAssertion.new(:name => 'assertion2', :success => false, :exception => SyntaxError.new)
              ])
      ]}
      it { is_expected.not_to eq nil }
    end
  end
end