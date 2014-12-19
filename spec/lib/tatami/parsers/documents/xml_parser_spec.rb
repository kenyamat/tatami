RSpec.describe Tatami::Parsers::Documents::XmlParser do

  let(:contents) { '<root><body><div class="warn">hello world</div></root>' }
  let(:sut) { Tatami::Parsers::Documents::XmlParser.new(contents) }

  describe '#exists_node' do

    context 'elements' do
      it 'returns true when a node exists' do
        result = sut.exists_node('/root/body/div')
        expect(result).to eq true
      end

      it 'returns false when a node does not exist' do
        result = sut.exists_node('/root/body/a')
        expect(result).to eq false
      end
    end

    context 'attributes' do
      it 'returns true when an attribute exists' do
        result = sut.exists_node('/root/body/div', 'class')
        expect(result).to eq true
      end

      it 'returns false when an attribute does not exist' do
        result = sut.exists_node('/root/body/div', 'style')
        expect(result).to eq false
      end
    end

  end

  describe '#get_document_value' do

    context 'elements' do
      it 'returns node value' do
        result = sut.get_document_value('/root/body/div')
        expect(result).to eq 'hello world'
      end

      it 'raises a exception when a node does not exist' do
        expect{ sut.get_document_value('/root/body/a') }.to raise_error
      end
    end

    context 'attributes' do
      it 'returns attribute value' do
        result = sut.get_document_value('/root/body/div', 'class')
        expect(result).to eq 'warn'
      end

      it 'raises a exception when an attribute does not exist' do
        expect{ sut.get_document_value('/root/body/div', 'style') }.to raise_error
      end
    end

  end

  describe '#get_document_values' do

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

    context 'elements' do
      it 'returns node values' do
        result = sut.get_document_values('/root/body/ul/li')
        expect(result.length).to eq 4
        expect(result[0]).to eq 'OK'
        expect(result[1]).to eq 'INFO'
        expect(result[2]).to eq 'WARN'
        expect(result[3]).to eq 'ERROR'
      end

      it 'returns an empty array when nodes not found' do
        result = sut.get_document_values('/root/body/ul/a')
        expect(result.length).to eq 0
      end
    end

    context 'attributes' do
      it 'returns attribute value' do
        result = sut.get_document_values('/root/body/ul/li', 'class')
        expect(result.length).to eq 4
        expect(result[0]).to eq 'ok'
        expect(result[1]).to eq 'info'
        expect(result[2]).to eq 'warn'
        expect(result[3]).to eq 'error'
      end

      it 'returns an empty array when nodes not found' do
        expect{ sut.get_document_values('/root/body/ul/li', 'style') }.to raise_error
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

    context 'valid xml document' do

      let(:contents) { '<shop><item/></shop>' }

      it 'returns true' do
        expect(sut.test_schema_with_xsd(xsd)).to eq true
      end
    end

    context 'invalid xml document' do

      let(:contents) { '<shop><price/></shop>' }

      it 'returns true' do
        expect(sut.test_schema_with_xsd(xsd)).to eq false
      end
    end

  end
end