RSpec.describe Tatami::Parsers::Csv::HttpRequestParser do
  describe '.parse' do
    let(:sut) { Tatami::Parsers::Csv::HttpRequestParser.parse(header, row, 'Actual') }

    context 'BaseUri' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 1, :children => [
            Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1)
        ])
      }
      let(:row) { [ nil, 'TargetSite' ] }
      it { expect(sut.name).to eq 'Actual' }
      it { expect(sut.base_uri).to eq 'TargetSite' }
    end

    context 'Headers' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 2, :children => [
            Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1),
            Tatami::Models::Csv::Header.new(:name => 'Headers', :depth => 2, :from => 2, :to => 2, :children => [
              Tatami::Models::Csv::Header.new(:name => 'User-Agent', :depth => 3, :from => 2, :to => 2)
            ])
        ])
      }
      let(:row) { [ nil, 'TargetSite', 'Mozilla/5.0' ] }
      it { expect(sut.headers['User-Agent']).to eq 'Mozilla/5.0' }
    end

    context 'Cookies' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 2, :children => [
            Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1),
            Tatami::Models::Csv::Header.new(:name => 'Cookies', :depth => 2, :from => 2, :to => 2, :children => [
                Tatami::Models::Csv::Header.new(:name => 'cookie0', :depth => 3, :from => 2, :to => 2)
            ])
        ])
      }
      let(:row) { [ nil, 'TargetSite', 'cookie0value' ] }
      it { expect(sut.cookies['cookie0']).to eq 'cookie0value' }
    end

    context 'PathInfos' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 1, :children => [
            Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1),
            Tatami::Models::Csv::Header.new(:name => 'PathInfos', :depth => 2, :from => 2, :to => 2)
        ])
      }
      let(:row) { [ nil, 'TargetSite', 'path' ] }
      it { expect(sut.path_infos[0]).to eq 'path' }
    end

    context 'QueryStrings' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 2, :children => [
            Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1),
            Tatami::Models::Csv::Header.new(:name => 'QueryStrings', :depth => 2, :from => 2, :to => 2, :children => [
                Tatami::Models::Csv::Header.new(:name => 'id', :depth => 3, :from => 2, :to => 2)
            ])
        ])
      }
      let(:row) { [ nil, 'TargetSite', 'abs' ] }
      it { expect(sut.query_strings['id']).to eq 'abs' }
    end

    context 'Fragment' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 1, :children => [
            Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1),
            Tatami::Models::Csv::Header.new(:name => 'Fragment', :depth => 2, :from => 2, :to => 2)
        ])
      }
      let(:row) { [ nil, 'TargetSite', 'links' ] }
      it { expect(sut.fragment).to eq 'links' }
    end

    context 'when all values are nil' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 1, :children => [
            Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1)
        ])
      }
      let(:row) { [ nil, nil ] }
      it { expect(sut).to eq nil }
    end

    context 'when null header is passed' do
      let(:row) { [ nil, 'TargetSite' ] }
      subject { Tatami::Parsers::Csv::HttpRequestParser.parse(nil, row, 'Actual') }
      it { expect { subject }.to raise_error(ArgumentError, /header must not be null/) }
    end

    context 'when null row is passed' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 1, :children => [
            Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1)
        ])
      }
      subject { Tatami::Parsers::Csv::HttpRequestParser.parse(header, nil, 'Actual') }
      it { expect { subject }.to raise_error(ArgumentError, /row must not be null/) }
    end

    context 'when null name is passed' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 1, :children => [
            Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1)
        ])
      }
      let(:row) { [ nil, 'TargetSite' ] }
      subject { Tatami::Parsers::Csv::HttpRequestParser.parse(header, row, nil) }
      it { expect { subject }.to raise_error(ArgumentError, /name must no be null/) }
    end

    context 'when there is no BaseUri' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 1, :children => [
            Tatami::Models::Csv::Header.new(:name => 'Headers', :depth => 2, :from => 1, :to => 1, :children => [
                Tatami::Models::Csv::Header.new(:name => 'User-Agent', :depth => 3, :from => 1, :to => 1)
            ])
        ])
      }
      let(:row) { [ nil, 'Mozilla/5.0' ] }
      subject { Tatami::Parsers::Csv::HttpRequestParser.parse(header, row, 'Actual') }
      it { expect { subject }.to raise_error(ArgumentError, /<BaseUri> should be not null/) }
    end
  end
end