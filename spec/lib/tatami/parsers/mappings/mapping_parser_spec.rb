RSpec.describe Tatami::Parsers::Mappings::MappingParser do
  describe '#parse' do
    subject { Tatami::Parsers::Mappings::MappingParser.parse(contents) }

    context 'when valid' do
      let(:contents) {
        <<-EOS
        <BaseUriMapping>
          <Item Key="en-US">http://en.wikipedia.org</Item>
          <Item Key="ja-JP">http://ja.wikipedia.org</Item>
        </BaseUriMapping>
        EOS
      }
      it { is_expected.to include('en-US' => 'http://en.wikipedia.org', 'ja-JP' => 'http://ja.wikipedia.org') }
    end

    context 'when invalid' do
      let(:contents) {
        <<-EOS
        <BaseUriMapping>
          <XX Key="en-US">http://en.wikipedia.org</Item>
          <XX Key="ja-JP">http://ja.wikipedia.org</Item>
        </BaseUriMapping>
        EOS
      }
      it { is_expected.to eq ({}) }
    end
  end
end