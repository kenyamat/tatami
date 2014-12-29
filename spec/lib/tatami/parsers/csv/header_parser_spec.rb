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
        it {
          expect(root.name).to eq 'Root'
          expect(root.children.length).to eq 2
          expect(root.depth).to eq (-1)
          expect(root.from).to eq 0
          expect(root.to).to eq 32
        }

        context 'Arrange' do
          let(:arrange) { sut.children[0] }
          it {
            expect(arrange.name).to eq 'Arrange'
            expect(arrange.depth).to eq 0
            expect(arrange.from).to eq 1
            expect(arrange.to).to eq 11
            expect(arrange.children.length).to eq 2
          }

          context 'HttpRequest Expected' do
            let(:expected) { arrange.children[0] }
            it {
              expect(expected.name).to eq 'HttpRequest Expected'
              expect(expected.depth).to eq 1
              expect(expected.from).to eq 1
              expect(expected.to).to eq 2
              expect(expected.children.length).to eq 2
            }

            context 'BaseUri' do
              let(:base_uri) { expected.children[0] }
              it {
                expect(base_uri.name).to eq 'BaseUri'
                expect(base_uri.depth).to eq 2
                expect(base_uri.from).to eq 1
                expect(base_uri.to).to eq 1
                expect(base_uri.children.length).to eq 0
              }
            end
          end

          context 'HttpRequest Actual' do
            let(:actual) { arrange.children[1] }
            it {
              expect(actual.name).to eq 'HttpRequest Actual'
              expect(actual.depth).to eq 1
              expect(actual.from).to eq 3
              expect(actual.to).to eq 11
              expect(actual.children.length).to eq 6
            }
          end
        end

        context 'Assertion' do
          let(:assertion) { sut.children[1] }
          it {
            expect(assertion.name).to eq 'Assertion'
            expect(assertion.depth).to eq 0
            expect(assertion.from).to eq 12
            expect(assertion.to).to eq 32
            expect(assertion.children.length).to eq 5
          }

          context 'Uri' do
            let(:uri) { assertion.children[0] }
            it {
              expect(uri.name).to eq 'Uri'
              expect(uri.depth).to eq 1
              expect(uri.from).to eq 12
              expect(uri.to).to eq 12
              expect(uri.children.length).to eq 0
            }
          end

          context 'StatusCode' do
            let(:status_code) { assertion.children[1] }
            it {
              expect(status_code.name).to eq 'StatusCode'
              expect(status_code.depth).to eq 1
              expect(status_code.from).to eq 13
              expect(status_code.to).to eq 13
              expect(status_code.children.length).to eq 0
            }
          end

          context 'Headers' do
            let(:headers) { assertion.children[2] }
            it {
              expect(headers.name).to eq 'Headers'
              expect(headers.depth).to eq 1
              expect(headers.from).to eq 14
              expect(headers.to).to eq 15
              expect(headers.children.length).to eq 2
            }
          end

          context 'Cookies' do
            let(:cookies) { assertion.children[3] }
            it {
              expect(cookies.name).to eq 'Cookies'
              expect(cookies.depth).to eq 1
              expect(cookies.from).to eq 16
              expect(cookies.to).to eq 17
              expect(cookies.children.length).to eq 2
            }
          end

          context 'Contents' do
            let(:contents) { assertion.children[4] }
            it {
              expect(contents.name).to eq 'Contents'
              expect(contents.depth).to eq 1
              expect(contents.from).to eq 18
              expect(contents.to).to eq 32
              expect(contents.children.length).to eq 6
            }
          end
        end
      end
    end
  end
end