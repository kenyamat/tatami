RSpec.describe Tatami::Models::Assertions::UriAssertion do
  let(:expected) { Tatami::Models::Arrange.new }
  let(:actual) { Tatami::Models::Arrange.new }
  let(:sut) { Tatami::Models::Assertions::UriAssertion.new }

  describe '#get_name' do
    it 'gets name' do
      expect(sut.get_name).to eq 'Uri'
    end
  end

  describe '#assert' do
    context 'success cases' do
      it 'successes' do
        actual.http_response = double('http_response', :uri => 'http://a.com/test/test1')
        sut.value = '/test/test1'
        expect(sut.assert(expected, actual)).to eq true
      end

      it 'successes' do
        actual.http_response = double('http_response', :uri => 'http://a.com/test?a=b')
        sut.value = '/test?a=b'
        expect(sut.assert(expected, actual)).to eq true
      end

      it 'successes' do
        actual.http_response = double('http_response', :uri => 'http://a.com/')
        sut.value = '/'
        expect(sut.assert(expected, actual)).to eq true
      end

      it 'successes' do
        actual.http_response = double('http_response', :uri => 'http://a.com')
        sut.value = '/'
        expect(sut.assert(expected, actual)).to eq true
      end
    end

    context 'fail cases' do
      it 'fails' do
        actual.http_response = double('http_response', :uri => 'http://a.com/test')
        sut.value = '/xxx'
        expect(sut.assert(expected, actual)).to eq false
      end

      it 'fails' do
        actual.http_response = double('http_response', :uri => 'http://a.com/?a=b')
        sut.value = '/'
        expect(sut.assert(expected, actual)).to eq false
      end
    end
  end
end