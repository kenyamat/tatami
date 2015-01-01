RSpec.describe Tatami::Parsers::Csv::TestCaseParser do
  describe '.parse' do
    context 'when valid' do
      let(:sut) { Tatami::Parsers::Csv::TestCaseParser.parse(header, data, resources) }
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Root', :depth => -1, :from => 0, :to => 2, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Arrange', :depth => 0, :from => 1, :to => 1, :children => [
              Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 1, :children => [
                  Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1)
              ])
          ]),
          Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 2, :to => 2, :children => [
              Tatami::Models::Csv::Header.new(:name => 'Uri', :depth => 1, :from => 2, :to => 2)
          ])
        ])
      }
      let(:data) { [[ 'test case 1', 'BaseUri', '/local' ]] }
      let(:resources) { {} }
      it {
        expect(sut.name).to eq 'test case 1'
        expect(sut.assertions.length).to eq 1
      }
    end

    context 'when header is null' do
      let(:header) { nil }
      let(:data) { [[ 'test case 1', 'BaseUri', '/local' ]] }
      let(:resources) { {} }
      subject { Tatami::Parsers::Csv::TestCaseParser.parse(header, data, resources) }
      it { expect { subject }.to raise_error(ArgumentError, /header should not be null/) }
    end

    context 'when data is null' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Root', :depth => -1, :from => 0, :to => 2, :children => [
            Tatami::Models::Csv::Header.new(:name => 'Arrange', :depth => 0, :from => 1, :to => 1, :children => [
                Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 1, :children => [
                    Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1)
                ])
            ]),
            Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 2, :to => 2, :children => [
                Tatami::Models::Csv::Header.new(:name => 'Uri', :depth => 1, :from => 2, :to => 2)
            ])
        ])
      }
      let(:data) { nil }
      let(:resources) { {} }
      subject { Tatami::Parsers::Csv::TestCaseParser.parse(header, data, resources) }
      it { expect { subject }.to raise_error(ArgumentError, /data should not be null/) }
    end

    context 'when data is empty' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Root', :depth => -1, :from => 0, :to => 2, :children => [
            Tatami::Models::Csv::Header.new(:name => 'Arrange', :depth => 0, :from => 1, :to => 1, :children => [
                Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 1, :children => [
                    Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1)
                ])
            ]),
            Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 2, :to => 2, :children => [
                Tatami::Models::Csv::Header.new(:name => 'Uri', :depth => 1, :from => 2, :to => 2)
            ])
        ])
      }
      let(:data) { [[]] }
      let(:resources) { {} }
      subject { Tatami::Parsers::Csv::TestCaseParser.parse(header, data, resources) }
      it { expect { subject }.to raise_error(Tatami::WrongFileFormatError, /Test case's format is invalid/) }
    end

    context 'when first data is empty' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Root', :depth => -1, :from => 0, :to => 2, :children => [
            Tatami::Models::Csv::Header.new(:name => 'Arrange', :depth => 0, :from => 1, :to => 1, :children => [
                Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 1, :children => [
                    Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1)
                ])
            ]),
            Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 2, :to => 2, :children => [
                Tatami::Models::Csv::Header.new(:name => 'Uri', :depth => 1, :from => 2, :to => 2)
            ])
        ])
      }
      let(:data) { [[ '' ]] }
      let(:resources) { {} }
      subject { Tatami::Parsers::Csv::TestCaseParser.parse(header, data, resources) }
      it { expect { subject }.to raise_error(Tatami::WrongFileFormatError, /Test case\'s format is invalid/) }
    end
  end
end