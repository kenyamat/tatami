RSpec.describe Tatami::Parsers::Csv::Assertions::ContentAssertionItemParser do
  describe '.parse' do
    let(:header) { Tatami::Models::Csv::Header.new(:name => 'Expected', :depth => 1, :from => 0, :to => 7, :children => [
        Tatami::Models::Csv::Header.new(:name => 'Key', :depth => 2, :from => 1, :to => 1),
        Tatami::Models::Csv::Header.new(:name => 'Value', :depth => 2, :from => 2, :to => 2),
        Tatami::Models::Csv::Header.new(:name => 'Query', :depth => 2, :from => 3, :to => 3),
        Tatami::Models::Csv::Header.new(:name => 'Attribute', :depth => 2, :from => 4, :to => 4),
        Tatami::Models::Csv::Header.new(:name => 'Exists', :depth => 2, :from => 5, :to => 5),
        Tatami::Models::Csv::Header.new(:name => 'Pattern', :depth => 2, :from => 6, :to => 6),
        Tatami::Models::Csv::Header.new(:name => 'Format', :depth => 2, :from => 7, :to => 7),
        Tatami::Models::Csv::Header.new(:name => 'FormatCulture', :depth => 2, :from => 8, :to => 8),
        Tatami::Models::Csv::Header.new(:name => 'UrlDecode', :depth => 2, :from => 9, :to => 9)
    ])}
    let(:sut) { Tatami::Parsers::Csv::Assertions::ContentAssertionItemParser.parse(header, row) }

    context 'when all values are set' do
      let(:row) { [ nil, 'key', 'value', 'query', 'attribute', 'true', 'pattern', 'format', 'en-US', 'true' ] }
      it {
        expect(sut.key).to eq 'key'
        expect(sut.value).to eq 'value'
        expect(sut.query).to eq 'query'
        expect(sut.attribute).to eq 'attribute'
        expect(sut.exists).to eq true
        expect(sut.pattern).to eq 'pattern'
        expect(sut.format).to eq 'format'
        expect(sut.format_culture).to eq 'en-US'
        expect(sut.url_decode).to eq true
      }
    end

    context 'when all values are nil' do
      let(:row) { [ nil, nil, nil, nil, nil, nil, nil, nil, nil, nil ] }
      it {
        expect(sut.key).to eq nil
        expect(sut.value).to eq nil
        expect(sut.query).to eq nil
        expect(sut.attribute).to eq nil
        expect(sut.exists).to eq nil
        expect(sut.pattern).to eq nil
        expect(sut.format).to eq nil
        expect(sut.format_culture).to eq nil
        expect(sut.url_decode).to eq false
      }
    end

  end
end