RSpec.describe Tatami::Models::Assertions::TextAssertion do
  let(:expected) { Tatami::Models::Arrange.new }
  let(:actual) { Tatami::Models::Arrange.new }
  let(:sut) { Tatami::Models::Assertions::TextAssertion.new }
  let(:sut_expected) { Tatami::Models::Assertions::ContentAssertionItem.new }
  let(:sut_actual) { Tatami::Models::Assertions::ContentAssertionItem.new }

  before do
    sut.expected = sut_expected
    sut.actual = sut_actual
  end

  describe '#match' do
    it 'succeeds' do
      expect(sut.match('aaa:bbb', ':(.*)')).to eq 'bbb'
    end

    it 'fails' do
      expect { sut.match('aaa', ':(.*)') } .to raise_error
    end
  end

  describe '#assert' do
    context 'exists' do
      before { sut_expected.exists = true }

      it 'succeeds' do
        actual.http_response = double('http_response', :exists_node => true)
        expect(sut.assert(expected, actual)).to eq true
      end

      it 'fails' do
        actual.http_response = double('http_response', :exists_node => false)
        expect(sut.assert(expected, actual)).to eq false
      end
    end

    context 'is not list' do
      it 'succeeds' do
        expected.http_response = double('e_http_response', :get_document_value => 'a')
        actual.http_response = double('a_http_response', :get_document_value => 'a')
        expect(sut.assert(expected, actual)).to eq true
      end

      it 'fails' do
        expected.http_response = double('e_http_response', :get_document_value => 'a')
        actual.http_response = double('a_http_response', :get_document_value => 'b')
        expect(sut.assert(expected, actual)).to eq false
      end

      it 'does url decode' do
        sut_expected.url_decode = true
        sut_actual.url_decode = true
        expected.http_response = double('e_http_response', :get_document_value => 'a%20b')
        actual.http_response = double('a_http_response', :get_document_value => 'a%20b')
        expect(sut.assert(expected, actual)).to eq true
      end

      it 'does regex match' do
        sut_expected.pattern = ':(.*)'
        expected.http_response = double('e_http_response', :get_document_value => 'cc:ab')
        actual.http_response = double('a_http_response', :get_document_value => 'ab')
        expect(sut.assert(expected, actual)).to eq true
      end
    end

    context 'is list' do
      before { sut.is_list = true }

      it 'succeeds' do
        expected.http_response = double('e_http_response', :get_document_values => %w(a b))
        actual.http_response = double('a_http_response', :get_document_values => %w(a b))
        expect(sut.assert(expected, actual)).to eq true
      end

      it 'fails' do
        expected.http_response = double('e_http_response', :get_document_values => %w(a b))
        actual.http_response = double('a_http_response', :get_document_values => %w(a c))
        expect(sut.assert(expected, actual)).to eq false
      end
    end
  end
end