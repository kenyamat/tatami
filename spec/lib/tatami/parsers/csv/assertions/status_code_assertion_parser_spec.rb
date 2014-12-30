RSpec.describe Tatami::Parsers::Csv::Assertions::StatusCodeAssertionParser do
  describe '.parse' do
    let(:sut) { Tatami::Parsers::Csv::Assertions::StatusCodeAssertionParser.parse(header, row) }
    let(:header) { Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 1, :from => 0, :to => 1, :children => [
        Tatami::Models::Csv::Header.new(:name => 'StatusCode', :depth => 2, :from => 1, :to => 1) ])}

    context 'when valid number' do
      let(:row) { [ nil, '200' ] }
      it {
        expect(sut[0]).to be_instance_of(Tatami::Models::Assertions::StatusCodeAssertion)
        expect(sut[0].value).to eq '200'
      }
    end

    context 'when value is nil' do
      let(:row) { [ nil, nil ] }
      it { expect(sut).to eq nil }
    end

    context 'when not valid number' do
      let(:row) { [ nil, 'aa' ] }
      it { expect { sut }.to raise_error(Tatami::Parsers::WrongFileFormatError, /Invalid Data Format/) }
    end
  end
end