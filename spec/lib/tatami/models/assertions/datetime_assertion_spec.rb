RSpec.describe Tatami::Models::Assertions::DateTimeAssertion do
  let(:expected) { Tatami::Models::Arrange.new }
  let(:actual) { Tatami::Models::Arrange.new }
  let(:sut) { Tatami::Models::Assertions::DateTimeAssertion.new }
  let(:sut_expected) { Tatami::Models::Assertions::ContentAssertionItem.new }
  let(:sut_actual) { Tatami::Models::Assertions::ContentAssertionItem.new }

  before do
    sut_expected.format = '%Y-%m-%d'
    sut_actual.format = '%Y-%m-%d'
    sut.expected = sut_expected
    sut.actual = sut_actual
  end

  describe '#assert' do
    context 'date' do
      context 'single date' do
        it 'succeeds' do
          expected.http_response = double('e_http_response', :get_document_value => '2014-12-20')
          actual.http_response = double('a_http_response', :get_document_value => '2014-12-20')
          expect(sut.assert(expected, actual)).to eq true
        end

        it 'fails' do
          expected.http_response = double('e_http_response', :get_document_value => '2014-12-20')
          actual.http_response = double('a_http_response', :get_document_value => '2014-12-21')
          expect(sut.assert(expected, actual)).to eq false
        end
      end

      context 'is list' do
        before { sut.is_list = true }

        it 'succeeds' do
          expected.http_response = double('e_http_response', :get_document_values => %w(2014-12-20 2014-12-21))
          actual.http_response = double('a_http_response', :get_document_values => %w(2014-12-20 2014-12-21))
          expect(sut.assert(expected, actual)).to eq true
        end

        it 'fails' do
          expected.http_response = double('e_http_response', :get_document_values => %w(2014-12-20 2014-12-21))
          actual.http_response = double('a_http_response', :get_document_values => %w(2014-12-21 2014-12-22))
          expect(sut.assert(expected, actual)).to eq false
        end
      end
    end

    context 'time' do
      before do
        sut.is_time = true
        sut_expected.format = '%H:%M:%S'
        sut_actual.format = '%H:%M:%S'
      end

      context 'single time' do
        it 'succeeds' do
          expected.http_response = double('e_http_response', :get_document_value => '23:50:10')
          actual.http_response = double('a_http_response', :get_document_value => '23:50:10')
          expect(sut.assert(expected, actual)).to eq true
        end

        it 'fails' do
          expected.http_response = double('e_http_response', :get_document_value => '23:50:10')
          actual.http_response = double('a_http_response', :get_document_value => '23:50:11')
          expect(sut.assert(expected, actual)).to eq false
        end
      end

      context 'is list' do
        before { sut.is_list = true }

        it 'succeeds' do
          expected.http_response = double('e_http_response', :get_document_values => %w(23:50:10 23:50:11))
          actual.http_response = double('a_http_response', :get_document_values => %w(23:50:10 23:50:11))
          expect(sut.assert(expected, actual)).to eq true
        end

        it 'fails' do
          expected.http_response = double('e_http_response', :get_document_values => %w(23:50:10 23:50:11))
          actual.http_response = double('a_http_response', :get_document_values => %w(23:50:11 23:50:12))
          expect(sut.assert(expected, actual)).to eq false
        end
      end
    end
  end
end