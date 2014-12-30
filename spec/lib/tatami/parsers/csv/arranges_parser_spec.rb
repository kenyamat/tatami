RSpec.describe Tatami::Parsers::Csv::ArrangesParser do
  describe '.parse' do
    context 'when valid' do
      let(:sut) { Tatami::Parsers::Csv::ArrangesParser.parse(header, row) }
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Arrange', :depth => 0, :from => 0, :to => 2, :children => [
            Tatami::Models::Csv::Header.new(:name => 'HttpRequest Expected', :depth => 1, :from => 1, :to => 1, :children => [
                Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1) ]),
            Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 2, :to => 2, :children => [
                Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 2, :to => 2) ])
        ])
      }
      let(:row) { [ nil, 'ExpectedSite', 'TargetSite' ] }
      it {
        expect(sut.expected.name).to eq 'Expected'
        expect(sut.actual.name).to eq 'Actual'
      }
    end

    context 'when header is null' do
      let(:header) { nil }
      let(:row) { [ nil, 'ExpectedSite', 'TargetSite' ] }
      subject { Tatami::Parsers::Csv::ArrangesParser.parse(header, row) }
      it { expect { subject }.to raise_error(ArgumentError, /header must not be null/) }
    end

    context 'when children is empty' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Arrange', :depth => 0, :from => 0, :to => 2, :children => [])
      }
      let(:row) { [] }
      subject { Tatami::Parsers::Csv::ArrangesParser.parse(header, row) }
      it { expect { subject }.to raise_error(ArgumentError, /header.Children must not be empty/) }
    end

    context 'when row is null' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Arrange', :depth => 0, :from => 0, :to => 2, :children => [
            Tatami::Models::Csv::Header.new(:name => 'HttpRequest Expected', :depth => 1, :from => 1, :to => 1, :children => [
                Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1) ]),
            Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 2, :to => 2, :children => [
                Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 2, :to => 2) ])
        ])
      }
      let(:row) { nil }
      subject { Tatami::Parsers::Csv::ArrangesParser.parse(header, row) }
      it { expect { subject }.to raise_error(ArgumentError, /data must not be null/) }
    end

    context 'when invalid header name' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Arrange', :depth => 0, :from => 0, :to => 2, :children => [
            Tatami::Models::Csv::Header.new(:name => 'XX', :depth => 1, :from => 1, :to => 1, :children => [
                Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1) ]),
            Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 2, :to => 2, :children => [
                Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 2, :to => 2) ])
        ])
      }
      let(:row) { [ nil, 'ExpectedSite', 'TargetSite' ] }
      subject { Tatami::Parsers::Csv::ArrangesParser.parse(header, row) }
      it { expect { subject }.to raise_error(Tatami::Parsers::WrongFileFormatError, /Invalid HttpRequest name/) }
    end

    context 'when there is no actual' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Arrange', :depth => 0, :from => 0, :to => 1, :children => [
            Tatami::Models::Csv::Header.new(:name => 'HttpRequest Expected', :depth => 1, :from => 1, :to => 1, :children => [
                Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1) ])
        ])
      }
      let(:row) { [ nil, 'ExpectedSite' ] }
      subject { Tatami::Parsers::Csv::ArrangesParser.parse(header, row) }
      it { expect { subject }.to raise_error(Tatami::Parsers::WrongFileFormatError, /HttpRequest Actual is empty/) }
    end
  end
end