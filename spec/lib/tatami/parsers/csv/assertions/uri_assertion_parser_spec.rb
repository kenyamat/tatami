RSpec.describe Tatami::Parsers::Csv::Assertions::UriAssertionParser do
  describe '.parse' do
    let(:sut) { Tatami::Parsers::Csv::Assertions::UriAssertionParser.parse(header, row) }
    let(:header) { Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 1, :from => 0, :to => 1, :children => [
        Tatami::Models::Csv::Header.new(:name => 'Uri', :depth => 2, :from => 1, :to => 1) ])}

    context 'when value starts slash' do
      let(:row) { [ nil, '/local' ] }
      it { expect(sut[0].value).to eq '/local' }
    end

    context 'when value is nil' do
      let(:row) { [ nil, nil ] }
      it { expect(sut).to eq nil }
    end

    context 'when value does not start slash' do
      let(:row) { [ nil, 'local' ] }
      it { expect { sut }.to raise_error(ArgumentError, /Invalid Data Format/) }
    end
  end
end