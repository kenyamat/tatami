RSpec.describe Tatami::Parsers::Csv::TestCasesParser do
  describe '.parse' do
    context 'when valid' do
      let(:sut) { Tatami::Parsers::Csv::TestCasesParser.parse(data, resources) }
      let(:data) {
        [
          [ nil, 'Arrange', nil, 'Assertion' ],
          [ nil, 'HttpRequest Actual', nil, 'Uri' ],
          [ nil , 'BaseUri', nil, nil ],
          [ nil, nil, nil, nil ],
          [ 'test case 1', 'TargetSite', nil, '/local' ],
          [ 'test case 2', 'TargetSite2', nil, nil ]
        ] }
      let(:resources) { {} }
      it { expect(sut.test_cases.length).to eq 2 }
    end

    context 'when data is empty' do
      let(:data) { [[]] }
      let(:resources) { {} }
      subject { Tatami::Parsers::Csv::TestCasesParser.parse(data, resources) }
      it { expect { subject }.to raise_error(ArgumentError, /data should not be null/) }
    end

    context 'when data is nil' do
      let(:data) { nil }
      let(:resources) { {} }
      subject { Tatami::Parsers::Csv::TestCasesParser.parse(data, resources) }
      it { expect { subject }.to raise_error(ArgumentError, /data should not be null/) }
    end
  end

  describe 'integration tests' do
    context 'when all test cases are successful' do
      let(:sut) { Tatami::Parsers::Csv::TestCasesParser.parse(data).test(http_request_service, http_request_service_for_expected) }
      let(:http_request_service_for_expected) { double('r_e', :get_response => Tatami::Models::HttpResponse.new(:contents => expected_doc, :content_type => 'text/xml')) }
      let(:http_request_service) { double('r_a', :get_response => Tatami::Models::HttpResponse.new(:contents => actual_doc, :content_type => 'text/html')) }
      let(:data) { [
          [ nil, 'Arrange', nil, 'Assertion', nil, nil, nil, nil ],
          [ nil, 'HttpRequest Expected', 'HttpRequest Actual', 'Contents', nil, nil, nil, nil ],
          [ nil, 'BaseUri', 'BaseUri', 'Name', 'Expected', nil, 'Actual', nil ],
          [ nil, nil, nil, nil, 'Query', 'Attribute', 'Query', 'Attribute' ],
          [ 'test case 1', 'ExpectedSite', 'TargetSite', 'text test 1', '//Expected/Item[1]', 'Name', '//html/body/ul/li[1]', nil ],
          [ nil, nil, nil, 'text test 2', '//Expected/Item[2]', 'Name', '//html/body/ul/li[2]', nil ],
        ] }
      let(:expected_doc) do
        <<-EOS
        <Expected>
          <Item Name='a' />
          <Item Name='b' />
        </Expected>
        EOS
      end
      let(:actual_doc) do
        <<-EOS
        <html><body>
          <ul>
              <li>a</li>
              <li>b</li>
          </ul>
        </body></html>
        EOS
      end
      it { expect(sut.success?).to eq true }
    end

    context 'when some cases are unsuccessful' do
      let(:sut) { Tatami::Parsers::Csv::TestCasesParser.parse(data).test(http_request_service, http_request_service_for_expected) }
      let(:http_request_service_for_expected) { double('r_e', :get_response => Tatami::Models::HttpResponse.new(:contents => expected_doc, :content_type => 'text/xml')) }
      let(:http_request_service) { double('r_a', :get_response => Tatami::Models::HttpResponse.new(:contents => actual_doc, :content_type => 'text/html')) }
      let(:data) { [
          [ nil, 'Arrange', nil, 'Assertion', nil, nil, nil, nil ],
          [ nil, 'HttpRequest Expected', 'HttpRequest Actual', 'Contents', nil, nil, nil, nil ],
          [ nil, 'BaseUri', 'BaseUri', 'Name', 'Expected', nil, 'Actual', nil ],
          [ nil, nil, nil, nil, 'Query', 'Attribute', 'Query', 'Attribute' ],
          [ 'test case 1', 'ExpectedSite', 'TargetSite', 'text test 1', '//Expected/Item[1]', 'Name', '//html/body/ul/li[1]', nil ],
          [ nil, nil, nil, 'text test 2', '//Expected/Item[2]', 'Name', '//html/body/ul/li[2]', nil ],
      ] }
      let(:expected_doc) do
        <<-EOS
        <Expected>
          <Item Name='a' />
          <Item Name='b' />
        </Expected>
        EOS
      end
      let(:actual_doc) do
        <<-EOS
        <html><body>
          <ul>
              <li>X</li>
              <li>X</li>
          </ul>
        </body></html>
        EOS
      end
      it { expect(sut.success?).to eq false }
      it { expect(sut.get_failed_cases.length).to eq 1 }
      it { expect(sut.get_failed_cases[0].get_failed_assertions.length).to eq 2 }
    end

    context 'when static cases' do
      let(:sut) { Tatami::Parsers::Csv::TestCasesParser.parse(data).test(http_request_service) }
      let(:http_request_service) { double('r_a', :get_response => Tatami::Models::HttpResponse.new(:contents => actual_doc, :content_type => 'text/html')) }
      let(:data) { [
          [ nil, 'Arrange', nil, 'Assertion', nil, nil, nil, nil ],
          [ nil, 'HttpRequest Expected', 'HttpRequest Actual', 'Contents', nil, nil, nil, nil ],
          [ nil, 'BaseUri', 'BaseUri', 'Name', 'Expected', nil, 'Actual', nil ],
          [ nil, nil, nil, nil, 'Value', 'Attribute', 'Query', 'Attribute' ],
          [ 'test case 1', 'ExpectedSte', 'TargetSite', 'text test 1', 'a', nil, '//html/body/ul/li[1]', nil ],
          [ nil, nil, nil, 'text test 2', 'b', nil, '//html/body/ul/li[2]', nil ],
      ] }
      let(:actual_doc) do
        <<-EOS
        <html><body>
          <ul>
              <li>a</li>
              <li>b</li>
          </ul>
        </body></html>
        EOS
      end
      it { expect(sut.success?).to eq true }
    end
  end
end