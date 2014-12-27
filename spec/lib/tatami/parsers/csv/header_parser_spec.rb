RSpec.describe Tatami::Parsers::Csv::HeaderParser do
  describe '.parse' do
    context 'when valid' do
      let(:sut) { Tatami::Parsers::Csv::HeaderParser.parse(CsvParser::Parser.new.parse(csv)) }
      let(:csv) do
        <<-EOS
        ,Arrange,,,,,,,,,,,Assertion,,,,,,,,,,,,,,,,,,,,
        ,HttpRequest Expected,,HttpRequest Actual,,,,,,,,,Uri,StatusCode,Headers,,Cookies,,Contents,,,,,,,,,,,,,,
        ,BaseUri,PathInfos,BaseUri,Headers,Cookies,,PathInfos,,QueryStrings,,Fragment,,,Content-Type,Last-Modified,Location,Degree,Name,IsList,IsDateTime,IsTime,Expected,,,,,,Actual,,,,
        ,,,,User-Agent,Location,Degree,,,locations,type,,,,,,,,,,,,Value,Query,Attribute,Pattern,Format,FormatCulture,Query,Attribute,Pattern,Format,FormatCulture
        EOS
      end

      context 'Root' do
        let(:root) { sut }
        it { expect(root.name).to eq 'Root' }
        it { expect(root.children.length).to eq 2 }
        it { expect(root.depth).to eq (-1) }
        it { expect(root.from).to eq 0 }
        it { expect(root.to).to eq 32 }

        context 'Arrange' do
          let(:arrange) { sut.children[0] }
          it { expect(arrange.name).to eq 'Arrange' }
          it { expect(arrange.depth).to eq 0 }
          it { expect(arrange.from).to eq 1 }
          it { expect(arrange.to).to eq 11 }
          it { expect(arrange.children.length).to eq 2 }

          context 'HttpRequest Expected' do
            let(:expected) { arrange.children[0] }
            it { expect(expected.name).to eq 'HttpRequest Expected' }
            it { expect(expected.depth).to eq 1 }
            it { expect(expected.from).to eq 1 }
            it { expect(expected.to).to eq 2 }
            it { expect(expected.children.length).to eq 2 }

            context 'BaseUri' do
              let(:base_uri) { expected.children[0] }
              it { expect(base_uri.name).to eq 'BaseUri' }
              it { expect(base_uri.depth).to eq 2 }
              it { expect(base_uri.from).to eq 1 }
              it { expect(base_uri.to).to eq 1 }
              it { expect(base_uri.children.length).to eq 0 }
            end
          end

          context 'HttpRequest Actual' do
            let(:actual) { arrange.children[1] }
            it { expect(actual.name).to eq 'HttpRequest Actual' }
            it { expect(actual.depth).to eq 1 }
            it { expect(actual.from).to eq 3 }
            it { expect(actual.to).to eq 11 }
            it { expect(actual.children.length).to eq 6 }
          end
        end

        context 'Assertion' do
          let(:assertion) { sut.children[1] }
          it { expect(assertion.name).to eq 'Assertion' }
          it { expect(assertion.depth).to eq 0 }
          it { expect(assertion.from).to eq 12 }
          it { expect(assertion.to).to eq 32 }
          it { expect(assertion.children.length).to eq 5 }

          context 'Uri' do
            let(:uri) { assertion.children[0] }
            it { expect(uri.name).to eq 'Uri' }
            it { expect(uri.depth).to eq 1 }
            it { expect(uri.from).to eq 12 }
            it { expect(uri.to).to eq 12 }
            it { expect(uri.children.length).to eq 0 }
          end

          context 'StatusCode' do
            let(:status_code) { assertion.children[1] }
            it { expect(status_code.name).to eq 'StatusCode' }
            it { expect(status_code.depth).to eq 1 }
            it { expect(status_code.from).to eq 13 }
            it { expect(status_code.to).to eq 13 }
            it { expect(status_code.children.length).to eq 0 }
          end

          context 'Headers' do
            let(:headers) { assertion.children[2] }
            it { expect(headers.name).to eq 'Headers' }
            it { expect(headers.depth).to eq 1 }
            it { expect(headers.from).to eq 14 }
            it { expect(headers.to).to eq 15 }
            it { expect(headers.children.length).to eq 2 }
          end

          context 'Cookies' do
            let(:cookies) { assertion.children[3] }
            it { expect(cookies.name).to eq 'Cookies' }
            it { expect(cookies.depth).to eq 1 }
            it { expect(cookies.from).to eq 16 }
            it { expect(cookies.to).to eq 17 }
            it { expect(cookies.children.length).to eq 2 }
          end

          context 'Contents' do
            let(:contents) { assertion.children[4] }
            it { expect(contents.name).to eq 'Contents' }
            it { expect(contents.depth).to eq 1 }
            it { expect(contents.from).to eq 18 }
            it { expect(contents.to).to eq 32 }
            it { expect(contents.children.length).to eq 6 }
          end
        end
      end
    end
  end
end