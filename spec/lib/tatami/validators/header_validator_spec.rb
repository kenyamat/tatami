RSpec.describe Tatami::Validators::Csv::HeaderValidator do
  describe '.validate' do
    subject { Tatami::Validators::Csv::HeaderValidator.validate(header) }

    context 'when valid' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Root', :depth => -1, :from => 0, :to => 1, :children => [
            Tatami::Models::Csv::Header.new(:name => 'Arrange', :depth => 0, :from => 0, :to => 0, :children => [
                Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 0, :to => 0, :children => [
                    Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 0, :to => 0)
                ])
            ]),
            Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 1, :to => 1, :children => [
                Tatami::Models::Csv::Header.new(:name => 'Uri', :depth => 1, :from => 1, :to => 1)
            ])
        ])
      }
      it { is_expected.to eq true }
    end

    context 'when invalid name' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'XX') }
      it { expect { subject }.to raise_error(ArgumentError, /Invalid Header Name/) }
    end

    context 'when invalid number of children' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Root', :depth => -1, :from => 0, :to => 1, :children => [
          Tatami::Models::Csv::Header.new({}),
          Tatami::Models::Csv::Header.new({}),
          Tatami::Models::Csv::Header.new({})
      ]) }
      it { expect { subject }.to raise_error(ArgumentError, /children is invalid/) }
    end
  end

  describe '.validate_arrange' do
    subject { Tatami::Validators::Csv::HeaderValidator.validate_arrange(header) }

    context 'when valid' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Arrange', :depth => 0, :from => 0, :to => 0, :children => [
            Tatami::Models::Csv::Header.new(:name => 'HttpRequest Expected', :depth => 1, :from => 0, :to => 0, :children => [
                Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 0, :to => 0)
            ]),
            Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 0, :to => 0, :children => [
                Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 0, :to => 0)
            ])
        ])
      }
      it { is_expected.to eq true }
    end

    context 'when there is no HttpRequest Actual' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Arrange', :depth => 0, :from => 0, :to => 0, :children => [
            Tatami::Models::Csv::Header.new(:name => 'HttpRequest Expected', :depth => 1, :from => 0, :to => 0, :children => [
                Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 0, :to => 0)
            ])
        ])
      }
      it { expect { subject }.to raise_error(ArgumentError, /Arrange should have <HttpRequest Actual>/) }
    end

    context 'when there is invalid node' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Arrange', :depth => 0, :from => 0, :to => 0, :children => [
            Tatami::Models::Csv::Header.new(:name => 'XXX', :depth => 1, :from => 0, :to => 0, :children => [
                Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 0, :to => 0)
            ]),
            Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 0, :to => 0, :children => [
                Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 0, :to => 0)
            ])
        ])
      }
      it { expect { subject }.to raise_error(ArgumentError, /<Arrange> has unknown child./) }
    end

    context 'when there is no children' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Arrange', :depth => 0, :from => 0, :to => 0, :children => []) }
      it { expect { subject }.to raise_error(ArgumentError, /Arrange's children are not found/) }
    end
  end

  describe '.validate_http_request' do
    subject { Tatami::Validators::Csv::HeaderValidator.validate_http_request(header) }

    context 'when valid' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 8, :children => [
            Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1),
            Tatami::Models::Csv::Header.new(:name => 'UserAgent', :depth => 2, :from => 2, :to => 2),
            Tatami::Models::Csv::Header.new(:name => 'PathInfos', :depth => 2, :from => 3, :to => 3),
            Tatami::Models::Csv::Header.new(:name => 'Fragment', :depth => 2, :from => 4, :to => 4),
            Tatami::Models::Csv::Header.new(:name => 'Headers', :depth => 2, :from => 5, :to => 5, :children => [
                Tatami::Models::Csv::Header.new(:name => 'Cache', :depth => 3, :from => 5, :to => 5)
            ]),
            Tatami::Models::Csv::Header.new(:name => 'Cookies', :depth => 2, :from => 6, :to => 6, :children => [
                Tatami::Models::Csv::Header.new(:name => 'TestCookie', :depth => 3, :from => 6, :to => 6)
            ]),
            Tatami::Models::Csv::Header.new(:name => 'QueryStrings', :depth => 2, :from => 7, :to => 7, :children => [
                Tatami::Models::Csv::Header.new(:name => 'TestQuery', :depth => 3, :from => 7, :to => 7)
            ]),
            Tatami::Models::Csv::Header.new(:name => 'Content', :depth => 2, :from => 8, :to => 8)
        ])
      }
      it { is_expected.to eq true }
    end

    context 'when header name is not valid' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'HttpRequest XX', :depth => 1, :from => 1, :to => 7, :children => [
            Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1),
        ])
      }
      it { expect { subject }.to raise_error(ArgumentError, /Invalid Header Name/) }
    end

    context 'when there is no BaseUri' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 7, :children => []) }
      it { expect { subject }.to raise_error(ArgumentError, /Actual should have <BaseUri> as his child/) }
    end

    context 'when there is invalid child' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 7, :children => [
            Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1),
            Tatami::Models::Csv::Header.new(:name => 'XX', :depth => 2, :from => 2, :to => 2),
        ])
      }
      it { expect { subject }.to raise_error(ArgumentError, /Invalid Header Format./) }
    end

    context 'when BaseUri has child' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 1, :children => [
            Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1, :children => [
                Tatami::Models::Csv::Header.new(:name => 'UserAgent', :depth => 3, :from => 1, :to => 1)
            ])
        ])
      }
      it { expect { subject }.to raise_error(ArgumentError, /<BaseUri> should have no children/) }
    end

    context 'when Headers has no child' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 1, :children => [
            Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1),
            Tatami::Models::Csv::Header.new(:name => 'Headers', :depth => 2, :from => 2, :to => 2)
        ])
      }
      it { expect { subject }.to raise_error(ArgumentError, /Headers should have children./) }
    end

    context 'when Fragment has child' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 1, :to => 1, :children => [
            Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 2, :from => 1, :to => 1),
            Tatami::Models::Csv::Header.new(:name => 'Fragment', :depth => 2, :from => 4, :to => 4, :children => [
                Tatami::Models::Csv::Header.new(:name => 'Cache', :depth => 3, :from => 4, :to => 4)
            ]),
        ])
      }
      it { expect { subject }.to raise_error(ArgumentError, /<Fragment> should have no children./) }
    end
  end

  describe '.validate_assertion' do
    subject { Tatami::Validators::Csv::HeaderValidator.validate_assertion(header) }

    context 'when valid' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 1, :to => 8, :children => [
            Tatami::Models::Csv::Header.new(:name => 'Uri', :depth => 1, :from => 1, :to => 1),
            Tatami::Models::Csv::Header.new(:name => 'StatusCode', :depth => 1, :from => 2, :to => 2),
            Tatami::Models::Csv::Header.new(:name => 'Headers', :depth => 1, :from => 3, :to => 3, :children => [
                Tatami::Models::Csv::Header.new(:name => 'Header1', :depth => 2, :from => 3, :to => 3)
            ]),
            Tatami::Models::Csv::Header.new(:name => 'Cookies', :depth => 1, :from => 4, :to => 4, :children => [
                Tatami::Models::Csv::Header.new(:name => 'Cookie1', :depth => 2, :from => 4, :to => 4)
            ]),
            Tatami::Models::Csv::Header.new(:name => 'Xsd', :depth => 1, :from => 5, :to => 5),
            Tatami::Models::Csv::Header.new(:name => 'Contents', :depth => 1, :from => 6, :to => 6, :children => [
                Tatami::Models::Csv::Header.new(:name => 'Name', :depth => 2, :from => 6, :to => 6),
                Tatami::Models::Csv::Header.new(:name => 'Expected', :depth => 2, :from => 7, :to => 7, :children => [
                    Tatami::Models::Csv::Header.new(:name => 'Value', :depth => 3, :from => 7, :to => 7)
                ]),
                Tatami::Models::Csv::Header.new(:name => 'Actual', :depth => 2, :from => 8, :to => 8, :children => [
                    Tatami::Models::Csv::Header.new(:name => 'Value', :depth => 3, :from => 8, :to => 8)
                ])
            ])
        ])
      }
      it { is_expected.to eq true }
    end

    context 'when invalid name' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'XX', :depth => 0, :from => 1, :to => 1, :children => [
            Tatami::Models::Csv::Header.new(:name => 'Uri', :depth => 1, :from => 1, :to => 1)
        ])
      }
      it { expect { subject }.to raise_error(ArgumentError, /Invalid Header Name. Expected=Assertion/) }
    end

    context 'when there is no children' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 1, :to => 1)
      }
      it { expect { subject }.to raise_error(ArgumentError, /Assertion should have children./) }
    end

    context 'when Uri has child' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 1, :to => 1, :children => [
            Tatami::Models::Csv::Header.new(:name => 'Uri', :depth => 1, :from => 1, :to => 1, :children => [
                Tatami::Models::Csv::Header.new(:name => 'XX', :depth => 2, :from => 1, :to => 1)
            ])
        ])
      }
      it { expect { subject }.to raise_error(ArgumentError, /<Uri> should have no children./) }
    end

    context 'when Headers has no child' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 1, :to => 1, :children => [
            Tatami::Models::Csv::Header.new(:name => 'Headers', :depth => 1, :from => 1, :to => 1)
        ])
      }
      it { expect { subject }.to raise_error(ArgumentError, /Headers should have children./) }
    end

    context 'when there is invalid child' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 1, :to => 1, :children => [
            Tatami::Models::Csv::Header.new(:name => 'XX', :depth => 1, :from => 1, :to => 1)
        ])
      }
      it { expect { subject }.to raise_error(ArgumentError, /<Assertion> has a unknown child. Name=XX/) }
    end
  end

  describe '.validate_contents' do
    subject { Tatami::Validators::Csv::HeaderValidator.validate_contents(header) }

    context 'when valid' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Contents', :depth => 1, :from => 1, :to => 3, :children => [
            Tatami::Models::Csv::Header.new(:name => 'Name', :depth => 2, :from => 1, :to => 1),
            Tatami::Models::Csv::Header.new(:name => 'IsList', :depth => 2, :from => 2, :to => 2),
            Tatami::Models::Csv::Header.new(:name => 'IsDateTime', :depth => 2, :from => 3, :to => 3),
            Tatami::Models::Csv::Header.new(:name => 'IsTime', :depth => 2, :from => 4, :to => 4),
            Tatami::Models::Csv::Header.new(:name => 'Expected', :depth => 2, :from => 5, :to => 5, :children => [
                Tatami::Models::Csv::Header.new(:name => 'Value', :depth => 3, :from => 5, :to => 5),
            ]),
            Tatami::Models::Csv::Header.new(:name => 'Actual', :depth => 2, :from => 6, :to => 6, :children => [
                Tatami::Models::Csv::Header.new(:name => 'Value', :depth => 3, :from => 6, :to => 6),
            ]),
        ])
      }
      it { is_expected.to eq true }
    end

    context 'when contents has no Actual' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Contents', :depth => 1, :from => 1, :to => 3, :children => [
            Tatami::Models::Csv::Header.new(:name => 'Name', :depth => 2, :from => 1, :to => 1),
            Tatami::Models::Csv::Header.new(:name => 'Expected', :depth => 2, :from => 2, :to => 2, :children => [
                Tatami::Models::Csv::Header.new(:name => 'Value', :depth => 3, :from => 2, :to => 2),
            ]),
        ])
      }
      it { expect { subject }.to raise_error(ArgumentError, /Contents should have <Actual> as his child./) }
    end

    context 'when Name has child' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Contents', :depth => 1, :from => 1, :to => 4, :children => [
            Tatami::Models::Csv::Header.new(:name => 'Name', :depth => 2, :from => 1, :to => 1, :children => [
                Tatami::Models::Csv::Header.new(:name => 'Value', :depth => 3, :from => 1, :to => 1)
            ]),
            Tatami::Models::Csv::Header.new(:name => 'Expected', :depth => 2, :from => 2, :to => 2, :children => [
                Tatami::Models::Csv::Header.new(:name => 'Value', :depth => 3, :from => 2, :to => 2),
            ]),
            Tatami::Models::Csv::Header.new(:name => 'Actual', :depth => 2, :from => 3, :to => 3, :children => [
                Tatami::Models::Csv::Header.new(:name => 'Value', :depth => 3, :from => 3, :to => 3),
            ]),
            Tatami::Models::Csv::Header.new(:name => 'XX', :depth => 2, :from => 4, :to => 4),
        ])
      }
      it { expect { subject }.to raise_error(ArgumentError, /<Name> should have no children./) }
    end

    context 'when there is invalid child' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Contents', :depth => 1, :from => 1, :to => 3, :children => [
            Tatami::Models::Csv::Header.new(:name => 'Name', :depth => 2, :from => 1, :to => 1),
            Tatami::Models::Csv::Header.new(:name => 'XXX', :depth => 2, :from => 2, :to => 2),
            Tatami::Models::Csv::Header.new(:name => 'Expected', :depth => 2, :from => 5, :to => 5, :children => [
                Tatami::Models::Csv::Header.new(:name => 'Value', :depth => 3, :from => 5, :to => 5),
            ]),
            Tatami::Models::Csv::Header.new(:name => 'Actual', :depth => 2, :from => 6, :to => 6, :children => [
                Tatami::Models::Csv::Header.new(:name => 'Value', :depth => 3, :from => 6, :to => 6),
            ]),
        ])
      }
      it { expect { subject }.to raise_error(ArgumentError, /<Contents> has a unknown child./) }
    end
  end

  describe '.validate_contents_item' do
    subject { Tatami::Validators::Csv::HeaderValidator.validate_contents_item(header) }

    context 'when valid' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Expected', :depth => 1, :from => 1, :to => 7, :children => [
            Tatami::Models::Csv::Header.new(:name => 'Value', :depth => 2, :from => 1, :to => 1),
            Tatami::Models::Csv::Header.new(:name => 'Query', :depth => 2, :from => 2, :to => 2),
            Tatami::Models::Csv::Header.new(:name => 'Attribute', :depth => 2, :from => 3, :to => 3),
            Tatami::Models::Csv::Header.new(:name => 'Exists', :depth => 2, :from => 4, :to => 4),
            Tatami::Models::Csv::Header.new(:name => 'Pattern', :depth => 2, :from => 5, :to => 5),
            Tatami::Models::Csv::Header.new(:name => 'Format', :depth => 2, :from => 6, :to => 6),
            Tatami::Models::Csv::Header.new(:name => 'FormatCulture', :depth => 2, :from => 7, :to => 7),
        ])
      }
      it { is_expected.to eq true }
    end

    context 'when there is invalid child' do
      let(:header) {
        Tatami::Models::Csv::Header.new(:name => 'Expected', :depth => 1, :from => 1, :to => 7, :children => [
            Tatami::Models::Csv::Header.new(:name => 'Value', :depth => 2, :from => 1, :to => 1),
            Tatami::Models::Csv::Header.new(:name => 'XX', :depth => 2, :from => 2, :to => 2),
        ])
      }
      it { expect { subject }.to raise_error(ArgumentError, /<Expected> has a unknown child. Name=XX/) }
    end

    context 'when there is no child' do
      let(:header) {

        Tatami::Models::Csv::Header.new(:name => 'Expected', :depth => 1, :from => 1, :to => 7, :children => [])
      }
      it { expect { subject }.to raise_error(ArgumentError, /Expected should have children./) }
    end

  end

  describe '.validate_not_nil' do
    subject { Tatami::Validators::Csv::HeaderValidator.validate_not_nil(header, name) }

    context 'when valid' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Contents', :depth => 1, :from => 1, :to => 3) }
      let(:name) {}
      it { is_expected.to eq true }
    end

    context 'when not valid' do
      let(:header) { nil }
      let(:name) { 'Contents' }
      it { expect { subject }.to raise_error(ArgumentError, /Header <Contents> is not found./) }
    end
  end

  describe '.validate_depth_from_to' do
    let(:depth) { -1 }
    subject { Tatami::Validators::Csv::HeaderValidator.validate_depth_from_to(header, depth) }

    context 'when valid' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Parent', :depth => -1, :from => 0, :to => 4, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Child1', :depth => 0, :from => 0, :to => 2),
          Tatami::Models::Csv::Header.new(:name => 'Child2', :depth => 0, :from => 2, :to => 4),
      ]) }
      it { is_expected.to eq true }
    end

    context 'when invalid from/to' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Parent', :depth => -1, :from => 1, :to => 0) }
      it { expect { subject }.to raise_error(ArgumentError, /<Parent>'s From\/To is invalid./) }
    end

    context 'when invalid depth' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Parent', :depth => -1, :from => 0, :to => 1, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Child', :depth => -1, :from => 0, :to => 0)
      ]) }
      it { expect { subject }.to raise_error(ArgumentError, /<Child>'s Depth is invalid. Expected=0, Actual=-1/) }
    end

    context 'when invalid from' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Parent', :depth => -1, :from => 1, :to => 2, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Child', :depth => 0, :from => 0, :to => 1)
      ]) }
      it { expect { subject }.to raise_error(ArgumentError, /<Child>'s From is invalid. <Child>'s From=0, Child's parent's From=1/) }
    end

    context 'when invalid to' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Parent', :depth => -1, :from => 0, :to => 0, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Child', :depth => 0, :from => 0, :to => 1)
      ]) }
      it { expect { subject }.to raise_error(ArgumentError, /<Child>'s To is invalid. <Child>'s To=1, Child's parent's To=0/) }
    end
  end

  describe '.validate_having_children' do
    let(:count) { nil }
    subject { Tatami::Validators::Csv::HeaderValidator.validate_having_children(header, count) }

    context 'when valid' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Parent', :depth => -1, :from => 0, :to => 4, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Child1', :depth => 0, :from => 0, :to => 2),
          Tatami::Models::Csv::Header.new(:name => 'Child2', :depth => 0, :from => 2, :to => 4),
      ]) }
      it { is_expected.to eq true }
    end

    context 'when children is empty' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Parent', :depth => -1, :from => 0, :to => 4, :children => []) }
      it { expect { subject }.to raise_error(ArgumentError, /Parent's children are not found/) }
    end

    context 'when invalid count' do
      let(:count) { 3 }
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Parent', :depth => -1, :from => 0, :to => 4, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Child1', :depth => 0, :from => 0, :to => 2),
          Tatami::Models::Csv::Header.new(:name => 'Child2', :depth => 0, :from => 2, :to => 4),
      ]) }
      it { expect { subject }.to raise_error(ArgumentError, /Count of <Parent>'s children is invalid. Expected=3, Actual=2/) }
    end
  end

  describe '.validate_not_having_children' do
    subject { Tatami::Validators::Csv::HeaderValidator.validate_not_having_children(header) }

    context 'when valid' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Parent', :depth => -1, :from => 0, :to => 4, :children => []) }
      it { is_expected.to eq true }
    end

    context 'when there is children' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Parent', :depth => -1, :from => 0, :to => 4, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Child1', :depth => 0, :from => 0, :to => 2),
          Tatami::Models::Csv::Header.new(:name => 'Child2', :depth => 0, :from => 2, :to => 4),
      ]) }
      it { expect { subject }.to raise_error(ArgumentError, /<Parent> should have no children./) }
    end
  end

  describe '.validate_not_having_grand_children' do
    subject { Tatami::Validators::Csv::HeaderValidator.validate_not_having_grand_children(header) }

    context 'when valid' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Parent', :depth => -1, :from => 0, :to => 4, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Child1', :depth => 0, :from => 0, :to => 2),
          Tatami::Models::Csv::Header.new(:name => 'Child2', :depth => 0, :from => 2, :to => 4),
      ]) }
      it { is_expected.to eq true }
    end

    context 'when there is grand children' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Parent', :depth => -1, :from => 0, :to => 4, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Child1', :depth => 0, :from => 0, :to => 2, :children => [
              Tatami::Models::Csv::Header.new(:name => 'Child2', :depth => 1, :from => 2, :to => 2),
          ]),
          Tatami::Models::Csv::Header.new(:name => 'Child2', :depth => 0, :from => 2, :to => 4),
      ]) }
      it { expect { subject }.to raise_error(ArgumentError, /<Parent> should have no grand children./) }
    end
  end
end