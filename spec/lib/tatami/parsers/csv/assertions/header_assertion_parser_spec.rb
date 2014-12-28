RSpec.describe Tatami::Parsers::Csv::Assertions::HeadersAssertionParser do
  describe '.parse' do
    let(:sut) { Tatami::Parsers::Csv::Assertions::HeadersAssertionParser.parse(header, row) }
    let(:header) { Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 1, :from => 0, :to => 2, :children => [
        Tatami::Models::Csv::Header.new(:name => 'Headers', :depth => 2, :from => 1, :to => 2, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Content-Type', :depth => 3, :from => 1, :to => 1),
          Tatami::Models::Csv::Header.new(:name => 'Last-Modified', :depth => 3, :from => 2, :to => 2)
        ])
    ])}

    context 'when all values are set' do
      let(:row) { [ nil, 'text/html', '15:29:20' ] }
      it { expect(sut.length).to eq 2 }
      it { expect(sut[0]).to be_instance_of(Tatami::Models::Assertions::HeaderAssertion) }
      it { expect(sut[0].key).to eq 'Content-Type' }
      it { expect(sut[0].value).to eq 'text/html' }
      it { expect(sut[1].key).to eq 'Last-Modified' }
      it { expect(sut[1].value).to eq '15:29:20' }
    end

    context 'when all values are nil' do
      let(:row) { [ nil, nil, nil ] }
      it { expect(sut).to eq nil }
    end
  end
end