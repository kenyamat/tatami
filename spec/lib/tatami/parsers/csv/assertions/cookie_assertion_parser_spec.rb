RSpec.describe Tatami::Parsers::Csv::Assertions::CookiesAssertionParser do
  describe '.parse' do
    let(:sut) { Tatami::Parsers::Csv::Assertions::CookiesAssertionParser.parse(header, row) }
    let(:header) { Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 1, :from => 0, :to => 2, :children => [
        Tatami::Models::Csv::Header.new(:name => 'Cookies', :depth => 2, :from => 1, :to => 2, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Cookie1', :depth => 3, :from => 1, :to => 1),
          Tatami::Models::Csv::Header.new(:name => 'Cookie2', :depth => 3, :from => 2, :to => 2)
        ])
    ])}

    context 'when all values are set' do
      let(:row) { [ nil, 'cookie1value', 'cookie2value' ] }
      it { expect(sut.length).to eq 2 }
      it { expect(sut[0]).to be_instance_of(Tatami::Models::Assertions::CookieAssertion) }
      it { expect(sut[0].key).to eq 'Cookie1' }
      it { expect(sut[0].value).to eq 'cookie1value' }
      it { expect(sut[1].key).to eq 'Cookie2' }
      it { expect(sut[1].value).to eq 'cookie2value' }
    end

    context 'when all values are nil' do
      let(:row) { [ nil, nil, nil ] }
      it { expect(sut).to eq nil }
    end
  end
end