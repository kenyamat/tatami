RSpec.describe Tatami::Parsers::Csv::Assertions::XsdAssertionParser do
  describe '.parse' do
    let(:resource) { { :xsd1 => 'xsd1value'} }
    let(:sut) { Tatami::Parsers::Csv::Assertions::XsdAssertionParser.parse(header, row, resource) }
    let(:header) { Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 1, :from => 0, :to => 1, :children => [
        Tatami::Models::Csv::Header.new(:name => 'Xsd', :depth => 2, :from => 1, :to => 1) ])}

    context 'when value is set' do
      let(:row) { [ nil, :xsd1 ] }
      it {
        expect(sut[0]).to be_instance_of(Tatami::Models::Assertions::XsdAssertion)
        expect(sut[0].xsd).to eq 'xsd1value'
      }
    end

    context 'when value is nil' do
      let(:row) { [ nil, nil ] }
      it { expect(sut).to eq nil }
    end

    context 'when resource is nil' do
      let(:row) { [ nil, 'xxx' ] }
      it { expect { sut }.to raise_error(ArgumentError, /Invalid Data Format/) }
    end
  end
end