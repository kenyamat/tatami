RSpec.describe Tatami::Parsers::Csv::Assertions::TextAssertionParser do
  describe '.parse' do
    let(:sut) { Tatami::Parsers::Csv::Assertions::TextAssertionParser.parse(header, row) }
    let(:header) { Tatami::Models::Csv::Header.new(:name => 'Contents', :depth => 2, :from => 0, :to => 4, :children => [
        Tatami::Models::Csv::Header.new(:name => 'Name', :depth => 3, :from => 1, :to => 1),
        Tatami::Models::Csv::Header.new(:name => 'IsList', :depth => 3, :from => 2, :to => 2),
        Tatami::Models::Csv::Header.new(:name => 'Expected', :depth => 3, :from => 3, :to => 3, :children => [
            Tatami::Models::Csv::Header.new(:name => 'Value', :depth => 4, :from => 3, :to => 3)
        ]),
        Tatami::Models::Csv::Header.new(:name => 'Actual', :depth => 3, :from => 4, :to => 4, :children => [
            Tatami::Models::Csv::Header.new(:name => 'Value', :depth => 4, :from => 4, :to => 4)
        ])
      ])}

    context 'when all values are set' do
      let(:row) { [ nil, 'name', 'true', 'a', 'b' ] }
      it {
        expect(sut[0]).to be_instance_of(Tatami::Models::Assertions::TextAssertion)
        expect(sut[0].name).to eq 'name'
        expect(sut[0].is_list).to eq true
        expect(sut[0].expected.value).to eq 'a'
        expect(sut[0].actual.value).to eq 'b'
      }
    end

    context 'when name is nil' do
      let(:row) { [ nil, nil, 'false', 'a', 'b' ] }
      it { expect { sut }.to raise_error(Tatami::WrongFileFormatError, /Invalid Data Format/) }
    end

    context 'when is_list is false' do
      let(:row) { [ nil, 'name', 'false', 'a', 'b' ] }
      it { expect(sut[0].is_list).to eq false }
    end

    context 'when is_list is nil' do
      let(:row) { [ nil, 'name', nil, 'a', 'b' ] }
      it { expect(sut[0].is_list).to eq false }
    end

    context 'when is_list is not valid' do
      let(:row) { [ nil, 'name', 'xxx', 'a', 'b' ] }
      it { expect { sut }.to raise_error }
    end
  end
end