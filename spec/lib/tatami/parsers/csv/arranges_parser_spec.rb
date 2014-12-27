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
      it { expect(sut.expected.name).to eq 'Expected' }
      it { expect(sut.actual.name).to eq 'Actual' }
    end

    context 'when header is null' do
      let(:header) { nil }
      let(:row) { [ nil, 'ExpectedSite', 'TargetSite' ] }
      subject { Tatami::Parsers::Csv::ArrangesParser.parse(header, row) }
      it { expect { subject }.to raise_error(ArgumentError) }
    end

    context 'when children is null' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Arrange', :depth => 0, :from => 0, :to => 2, :children => nil)
      }
      let(:row) { nil }
      subject { Tatami::Parsers::Csv::ArrangesParser.parse(header, row) }
      it { expect { subject }.to raise_error(ArgumentError) }
    end

    context 'when children is empty' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Arrange', :depth => 0, :from => 0, :to => 2, :children => [])
      }
      let(:row) { nil }
      subject { Tatami::Parsers::Csv::ArrangesParser.parse(header, row) }
      it { expect { subject }.to raise_error(ArgumentError) }
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
      it { expect { subject }.to raise_error(ArgumentError) }
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
      it { expect { subject }.to raise_error(ArgumentError) }
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
      it { expect { subject }.to raise_error(ArgumentError) }
    end
  end
end