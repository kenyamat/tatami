RSpec.describe Tatami::Parsers::Documents::XmlParser do
  let(:sut) { Tatami::Parsers::Documents::XmlParser.new(contents) }
  let(:contents) { '<root><body><div class="warn">hello world</div></root>' }

  describe '#exists_node?' do
    let(:attr_name) {}
    subject { sut.exists_node?(xpath, attr_name) }
    
    context 'elements' do
      context 'when node is found' do
        let(:xpath) { '/root/body/div' }
        it { is_expected.to eq true }
      end

      context 'when node is not found' do
        let(:xpath) { '/root/body/a' }
        it { is_expected.to eq false }
      end
    end
    
    context 'attributes' do
      context 'when attribute is found' do
        let(:xpath) { '/root/body/div' }
        let(:attr_name) { 'class' }
        it { is_expected.to eq true }
      end

      context 'when attribute is not found' do
        let(:xpath) { '/root/body/div' }
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
        let(:xpath) { '/root/body/div' }
        it { is_expected.to eq 'hello world' }
      end

      context 'when node is not found' do
        let(:xpath) { '/root/body/a' }
        it { expect { subject }.to raise_error(ArgumentError, /node not found./) }
      end
    end

    context 'attributes' do
      context 'when attribute is found' do
        let(:xpath) { '/root/body/div' }
        let(:attr_name) { 'class' }
        it { is_expected.to eq 'warn' }
      end

      context 'when attribute is not found' do
        let(:xpath) { '/root/body/div' }
        let(:attr_name) { 'style' }
        it { expect { subject }.to raise_error(ArgumentError, /attribute not found./) }
      end
    end
  end

  describe '#get_document_values' do
    let(:attr_name) {}
    let(:contents) do
      <<-EOS
      <root><body><ul>
        <li class="ok">OK</li>
        <li class="info">INFO</li>
        <li class="warn">WARN</li>
        <li class="error">ERROR</li>
      </ul></body></root>
      EOS
    end
    subject { sut.get_document_values(xpath, attr_name) }

    context 'elements' do
      context 'when nodes are found' do
        let(:xpath) { '/root/body/ul/li' }
        it { is_expected.to eq %w(OK INFO WARN ERROR) }
      end

      context 'when nodes are not found' do
        let(:xpath) { '/root/body/ul/a' }
        it { is_expected.to eq [] }
      end
    end

    context 'attributes' do
      context 'when attributes are found' do
        let(:xpath) { '/root/body/ul/li' }
        let(:attr_name) { 'class' }
        it { is_expected.to eq %w(ok info warn error) }
      end

      context 'when attributes are not found' do
        let(:xpath) { '/root/body/ul/li' }
        let(:attr_name) { 'style' }
        it { expect { subject }.to raise_error(ArgumentError, /attribute not found/) }
      end
    end
  end

  describe '#test_schema_with_xsd' do
    let(:xsd) do
      <<-EOS
      <?xml version="1.0" encoding="utf-8"?>
      <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
        <xs:element name="shop">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="item" minOccurs="1" maxOccurs="unbounded" />
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:schema>
      EOS
    end
    subject { sut.test_schema_with_xsd(xsd) }

    context 'when valid' do
      let(:contents) { '<shop><item/></shop>' }
      it { is_expected.to eq true }
    end

    context 'when not valid' do
      let(:contents) { '<shop><price/></shop>' }
      it { is_expected.to eq false }
    end
  end
end