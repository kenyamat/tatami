RSpec.describe Tatami::Parsers::Csv::Assertions::DateTimeAssertionParser do
  describe '.parse' do
    let(:sut) { Tatami::Parsers::Csv::Assertions::DateTimeAssertionParser.parse(header, row) }
    let(:header) { Tatami::Models::Csv::Header.new(:name => 'Contents', :depth => 2, :from => 0, :to => 6, :children => [
        Tatami::Models::Csv::Header.new(:name => 'Name', :depth => 3, :from => 1, :to => 1),
        Tatami::Models::Csv::Header.new(:name => 'IsList', :depth => 3, :from => 2, :to => 2),
        Tatami::Models::Csv::Header.new(:name => 'IsDateTime', :depth => 3, :from => 3, :to => 3),
        Tatami::Models::Csv::Header.new(:name => 'IsTime', :depth => 3, :from => 4, :to => 4),
        Tatami::Models::Csv::Header.new(:name => 'Expected', :depth => 3, :from => 5, :to => 5, :children => [
            Tatami::Models::Csv::Header.new(:name => 'Value', :depth => 4, :from => 5, :to => 5)
        ]),
        Tatami::Models::Csv::Header.new(:name => 'Actual', :depth => 3, :from => 6, :to => 6, :children => [
            Tatami::Models::Csv::Header.new(:name => 'Value', :depth => 4, :from => 6, :to => 6)
        ])
      ])}

    context 'when all values are set' do
      let(:row) { [ nil, 'name', 'true', 'true', 'true', 'a', 'b' ] }
      it { expect(sut[0].name).to eq 'name' }
      it { expect(sut[0].is_list).to eq true }
      it { expect(sut[0].is_time).to eq true }
      it { expect(sut[0].expected.value).to eq 'a' }
      it { expect(sut[0].actual.value).to eq 'b' }
    end

    context 'when is_list is false' do
      let(:row) { [ nil, 'name', 'false', 'true', 'true', 'a', 'b' ] }
      it { expect(sut[0].is_list).to eq false }
    end

    context 'when is_list is nil' do
      let(:row) { [ nil, 'name', nil, 'true', 'true', 'a', 'b' ] }
      it { expect(sut[0].is_list).to eq false }
    end

    context 'when is_time is false' do
      let(:row) { [ nil, 'name', 'true', 'true', 'false', 'a', 'b' ] }
      it { expect(sut[0].is_time).to eq false }
    end

    context 'when is_time is nil' do
      let(:row) { [ nil, 'name', 'true', 'true', nil, 'a', 'b' ] }
      it { expect(sut[0].is_time).to eq false }
    end

    context 'when name is nil' do
      let(:row) { [ nil, nil, 'true', 'true', nil, 'a', 'b' ] }
      it { expect { sut }.to raise_error }
    end
  end
end