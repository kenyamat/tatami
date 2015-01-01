RSpec.describe Tatami::Parsers::Csv::Assertions::AssertionsParser do
  describe '.parse' do
    let(:sut) { Tatami::Parsers::Csv::Assertions::AssertionsParser.parse(header, row, resources) }
    let(:resources) { {} }

    context 'Uri' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 0, :to => 1, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Uri', :depth => 1, :from => 1, :to => 1)
      ])}
      let(:row) { [[ nil, '/local' ]] }
      it { expect(sut[0].value).to eq '/local' }
    end

    context 'StatusCode' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 0, :to => 1, :children => [
          Tatami::Models::Csv::Header.new(:name => 'StatusCode', :depth => 1, :from => 1, :to => 1)
      ])}
      let(:row) { [[ nil, '200' ]] }
      it { expect(sut[0].value).to eq '200' }
    end

    context 'Headers' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 0, :to => 2, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Headers', :depth => 1, :from => 1, :to => 2, :children => [
              Tatami::Models::Csv::Header.new(:name => 'Content-Type', :depth => 2, :from => 1, :to => 1),
              Tatami::Models::Csv::Header.new(:name => 'Last-Modified', :depth => 2, :from => 2, :to => 2)])
          ])}
      let(:row) { [[ nil, 'text/html', '15:29:20' ]] }
      it {
        expect(sut[0].key).to eq 'Content-Type'
        expect(sut[0].value).to eq 'text/html'
        expect(sut[1].key).to eq 'Last-Modified'
        expect(sut[1].value).to eq '15:29:20'
      }
    end

    context 'Cookies' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 0, :to => 2, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Cookies', :depth => 1, :from => 1, :to => 2, :children => [
              Tatami::Models::Csv::Header.new(:name => 'Cookie1', :depth => 2, :from => 1, :to => 1),
              Tatami::Models::Csv::Header.new(:name => 'Cookie2', :depth => 2, :from => 2, :to => 2)])
      ])}
      let(:row) { [[ nil, 'cookie1value', 'cookie2value' ]] }
      it {
        expect(sut[0].key).to eq 'Cookie1'
        expect(sut[0].value).to eq 'cookie1value'
        expect(sut[1].key).to eq 'Cookie2'
        expect(sut[1].value).to eq 'cookie2value'
      }
    end

    context 'XSD' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 0, :to => 1, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Xsd', :depth => 1, :from => 1, :to => 1)
      ])}
      let(:row) { [[ nil, :xsd1 ]] }
      let(:resources) { { :xsd1 => 'xsd1value'} }
      it { expect(sut[0].xsd).to eq 'xsd1value' }
    end

    context 'Contents' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 0, :to => 3, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Contents', :depth => 1, :from => 1, :to => 3, :children => [
              Tatami::Models::Csv::Header.new(:name => 'Name', :depth => 2, :from => 1, :to => 1),
              Tatami::Models::Csv::Header.new(:name => 'IsDateTime', :depth => 2, :from => 2, :to => 2),
              Tatami::Models::Csv::Header.new(:name => 'IsTime', :depth => 2, :from => 3, :to => 3),
          ])
      ])}
      let(:row) { [
          [ nil, 'DateTime Test', 'true', nil ],
          [ nil, 'Time Test', nil, 'true' ]
      ] }
      it {
        expect(sut[0].is_time).to eq false
        expect(sut[1].is_time).to eq true
      }
    end

    context 'no item' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 0, :to => 3, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Contents', :depth => 1, :from => 1, :to => 3, :children => [
              Tatami::Models::Csv::Header.new(:name => 'Name', :depth => 2, :from => 1, :to => 1),
              Tatami::Models::Csv::Header.new(:name => 'IsDateTime', :depth => 2, :from => 2, :to => 2),
              Tatami::Models::Csv::Header.new(:name => 'IsTime', :depth => 2, :from => 3, :to => 3),
          ])
      ])}
      let(:row) { [[ nil, nil, nil, nil]] }
      it { expect(sut.length).to eq 0 }
    end

    context 'when invalid assertion name is passed' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 0, :to => 1, :children => [
          Tatami::Models::Csv::Header.new(:name => 'XXX', :depth => 1, :from => 1, :to => 1)
      ])}
      let(:row) { [[ nil, 'test' ]] }
      it { expect { sut }.to raise_error(Tatami::WrongFileFormatError, /Invalid Assertion name/) }
    end
  end
end