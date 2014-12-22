RSpec.describe Tatami::Parsers::Documents::HtmlParser do
  let(:sut) { Tatami::Parsers::Documents::HtmlParser.new(contents) }
  let(:contents) { '<html><body><div class="warn">hello world</div></html>' }

  describe '#exists_node?' do
    let(:attr_name) {}
    subject { sut.exists_node?(xpath, attr_name) }

    context 'elements' do
      context 'when node is found' do
        let(:xpath) { '/html/body/div' }
        it { is_expected.to eq true }
      end

      context 'when node is not found' do
        let(:xpath) { '/html/body/a' }
        it { is_expected.to eq false }
      end
    end

    context 'attributes' do
      context 'when attribute is found' do
        let(:xpath) { '/html/body/div' }
        let(:attr_name) { 'class' }
        it { is_expected.to eq true }
      end

      context 'when attribute is not found' do
        let(:xpath) { '/html/body/div' }
        let(:attr_name) { 'style' }
        it { is_expected.to eq false }
      end
    end
  end

  describe '#get_document_value' do
    let(:attr_name) {}
    subject { sut.get_document_value(xpath, attr_name) }

    context 'elements' do
      context 'when node is found' do
        let(:xpath) { '/html/body/div' }
        it { is_expected.to eq 'hello world' }
      end

      context 'when node is not found' do
        let(:xpath) { '/html/body/a' }
        it { expect { subject }.to raise_error }
      end
    end

    context 'attributes' do
      context 'when attribute is found' do
        let(:xpath) { '/html/body/div' }
        let(:attr_name) { 'class' }
        it { is_expected.to eq 'warn' }
      end

      context 'when attribute is not found' do
        let(:xpath) { '/html/body/div' }
        let(:attr_name) { 'style' }
        it { expect { subject }.to raise_error }
      end
    end
  end

  describe '#get_document_values' do
    let(:attr_name) {}
    let(:contents) do
      <<-EOS
      <html><head></head><body><ul>
        <li class="ok">OK</li>
        <li class="info">INFO</li>
        <li class="warn">WARN</li>
        <li class="error">ERROR</li>
      </ul></body></html>
      EOS
    end
    subject { sut.get_document_values(xpath, attr_name) }

    context 'elements' do
      context 'when nodes are found' do
        let(:xpath) { '/html/body/ul/li' }
        it { is_expected.to eq %w(OK INFO WARN ERROR) }
      end

      context 'when nodes are not found' do
        let(:xpath) { '/html/body/ul/a' }
        it { is_expected.to eq [] }
      end
    end

    context 'attributes' do
      context 'when attributes are found' do
        let(:xpath) { '/html/body/ul/li' }
        let(:attr_name) { 'class' }
        it { is_expected.to eq %w(ok info warn error) }
      end

      context 'when attributes are not found' do
        let(:xpath) { '/html/body/ul/li' }
        let(:attr_name) { 'style' }
        it { expect { subject }.to raise_error }
      end
    end
  end
end