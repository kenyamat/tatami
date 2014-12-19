require 'spec_helper'

RSpec.describe Tatami::Models::HttpRequest do

  let(:html) { '<html><body><div class="warn">hello world</div></html>' }
  let(:sut) { Tatami::Parsers::Documents::HtmlParser.new(html) }

  describe '#exists_node' do

    context 'elements' do
      it 'returns true when a node exists' do
        result = sut.exists_node('/html/body/div')
        expect(result).to eq true
      end

      it 'returns false when a node does not exist' do
        result = sut.exists_node('/html/body/a')
        expect(result).to eq false
      end
    end

    context 'attributes' do
      it 'returns true when an attribute exists' do
        result = sut.exists_node('/html/body/div', 'class')
        expect(result).to eq true
      end

      it 'returns false when an attribute does not exist' do
        result = sut.exists_node('/html/body/div', 'style')
        expect(result).to eq false
      end
    end

  end

  describe '#get_document_value' do

    context 'elements' do
      it 'returns node value' do
        result = sut.get_document_value('/html/body/div')
        expect(result).to eq 'hello world'
      end

      it 'raises a exception when a node does not exist' do
        expect{ sut.get_document_value('/html/body/a') }.to raise_error
      end
    end

    context 'attributes' do
      it 'returns attribute value' do
        result = sut.get_document_value('/html/body/div', 'class')
        expect(result).to eq 'warn'
      end

      it 'raises a exception when an attribute does not exist' do
        expect{ sut.get_document_value('/html/body/div', 'style') }.to raise_error
      end
    end

  end

  describe '#get_document_values' do

    let(:html) { '<html><body><div class="warn">hello world</div></html>' }

    let(:html) do
      <<-EOS
      <html><head></head><body><ul>
        <li class="ok">OK</li>
        <li class="info">INFO</li>
        <li class="warn">WARN</li>
        <li class="error">ERROR</li>
      </ul></body></html>
      EOS
    end

    context 'elements' do
      it 'returns node values' do
        result = sut.get_document_values('/html/body/ul/li')
        expect(result.length).to eq 4
        expect(result[0]).to eq 'OK'
        expect(result[1]).to eq 'INFO'
        expect(result[2]).to eq 'WARN'
        expect(result[3]).to eq 'ERROR'
      end

      it 'returns an empty array when nodes not found' do
        result = sut.get_document_values('/html/body/ul/a')
        expect(result.length).to eq 0
      end
    end

    context 'attributes' do
      it 'returns attribute value' do
        result = sut.get_document_values('/html/body/ul/li', 'class')
        expect(result.length).to eq 4
        expect(result[0]).to eq 'ok'
        expect(result[1]).to eq 'info'
        expect(result[2]).to eq 'warn'
        expect(result[3]).to eq 'error'
      end

      it 'returns an empty array when nodes not found' do
        expect{ sut.get_document_values('/html/body/ul/li', 'style') }.to raise_error
      end
    end

    
  end
end