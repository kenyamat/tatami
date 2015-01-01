RSpec.describe Tatami::Models::Csv::Header do
  let(:param) {}
  let(:sut) { Tatami::Models::Csv::Header.new(content_type: content_type, contents: contents) }

  describe '.get_parent' do
    context 'when limit values are passed' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Root', :depth => -1, :from => 0, :to => 30, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Arrange', :depth => 0, :from => 1, :to => 11),
          Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 12, :to => 30) ])}

      subject { Tatami::Models::Csv::Header.get_parent(header, depth, index).name }

      context 'index is 3' do
        let(:depth) { 1 }
        let(:index) { 3 }
        it { is_expected.to eq 'Arrange' }
      end
      context 'index is 11' do
        let(:depth) { 1 }
        let(:index) { 11 }
        it { is_expected.to eq 'Arrange' }
      end
      context 'index is 12' do
        let(:depth) { 1 }
        let(:index) { 12 }
        it { is_expected.to eq 'Assertion' }
      end
      context 'index is 30' do
        let(:depth) { 1 }
        let(:index) { 30 }
        it { is_expected.to eq 'Assertion' }
      end
      context 'index is 31' do
        let(:depth) { 1 }
        let(:index) { 31 }
        it { expect { subject }.to raise_error(Tatami::WrongFileFormatError, /Invalid header structure/) }
      end
    end

    context 'when structure is invalid' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Root', :depth => 1) }
      subject { Tatami::Models::Csv::Header.get_parent(header, 0, 1) }
      it { expect { subject }.to raise_error(Tatami::WrongFileFormatError, /depth <= header.depth/) }
    end
  end

  describe '.get_header' do
    context 'when depth is nil' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Root', :depth => -1, :from => 0, :to => 30, :children => [
                      Tatami::Models::Csv::Header.new(:name => 'Arrange', :depth => 0, :from => 1, :to => 11, :children =>[
                          Tatami::Models::Csv::Header.new(:name => 'HttpRequest Expected', :depth => 1, :from => 1, :to => 5),
                          Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 5, :to => 11),
                      ]),
                      Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 12, :to => 30, :children => [
                          Tatami::Models::Csv::Header.new(:name => 'Uri', :depth => 1, :from => 12, :to => 12)
                      ])
                    ])}

      subject { Tatami::Models::Csv::Header.get_header(header, index).name }

      context 'index is 1' do
        let(:index) { 1 }
        it { is_expected.to eq 'HttpRequest Expected' }
      end
      context 'index is 11' do
        let(:index) { 11 }
        it { is_expected.to eq 'HttpRequest Actual' }
      end
      context 'index is 12' do
        let(:index) { 12 }
        it { is_expected.to eq 'Uri' }
      end
    end

    context 'when depth is not nil' do
      let(:header) { Tatami::Models::Csv::Header.new(:name => 'Root', :depth => -1, :from => 0, :to => 30, :children => [
          Tatami::Models::Csv::Header.new(:name => 'Arrange', :depth => 0, :from => 1, :to => 11, :children =>[
              Tatami::Models::Csv::Header.new(:name => 'HttpRequest Expected', :depth => 1, :from => 1, :to => 5),
              Tatami::Models::Csv::Header.new(:name => 'HttpRequest Actual', :depth => 1, :from => 5, :to => 11),
          ]),
          Tatami::Models::Csv::Header.new(:name => 'Assertion', :depth => 0, :from => 12, :to => 30, :children => [
              Tatami::Models::Csv::Header.new(:name => 'Uri', :depth => 1, :from => 12, :to => 12)
          ])
      ])}

      subject { Tatami::Models::Csv::Header.get_header(header, index, depth).name }

      context ':index => 1 and :depth => 0' do
        let(:index) { 1 }
        let(:depth) { 0 }
        it { is_expected.to eq 'Arrange' }
      end
      context ':index => 1 and :depth => 1' do
        let(:index) { 1 }
        let(:depth) { 1 }
        it { is_expected.to eq 'HttpRequest Expected' }
      end
      context ':index => 11 and :depth => 0' do
        let(:index) { 11 }
        let(:depth) { 0 }
        it { is_expected.to eq 'Arrange' }
      end
      context ':index => 11 and :depth => 1' do
        let(:index) { 11 }
        let(:depth) { 1 }
        it { is_expected.to eq 'HttpRequest Actual' }
      end
      context ':index => 12 and :depth => 0' do
        let(:index) { 12 }
        let(:depth) { 0 }
        it { is_expected.to eq 'Assertion' }
      end
      context ':index => 30 and :depth => 1' do
        let(:index) { 30 }
        let(:depth) { 1 }
        subject { Tatami::Models::Csv::Header.get_header(header, index, depth) }
        it { is_expected.to eq nil }
      end
    end
  end

  describe '.search' do
    let(:header) { Tatami::Models::Csv::Header.new(:name => 'HttpRequest Expected', :depth => 2, :from => 1, :to => 3, :children => [
                    Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 3, :from => 1, :to => 1),
                    Tatami::Models::Csv::Header.new(:name => 'PathInfo', :depth => 3, :from => 2, :to => 3)
                  ])}

    context 'when name is existed' do
      let(:header_name) { 'BaseUri' }
      subject { Tatami::Models::Csv::Header.search(header, header_name).name }
      it { is_expected.to eq 'BaseUri' }
    end

    context 'when name is not existed' do
      let(:header_name) { 'QueryStrings' }
      subject { Tatami::Models::Csv::Header.search(header, header_name) }
      it { is_expected.to eq nil }
    end
  end

  describe '.get_string' do
    let(:header) { Tatami::Models::Csv::Header.new(:name => 'HttpRequest Expected', :depth => 2, :from => 1, :to => 3, :children => [
        Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 3, :from => 1, :to => 1),
        Tatami::Models::Csv::Header.new(:name => 'Fragment', :depth => 3, :from => 2, :to => 2)
    ])}
    let(:row) { ['case name', 'ExpectedSite', nil] }
    subject { Tatami::Models::Csv::Header.get_string(header, header_name, row) }

    context 'when name is existed' do
      let(:header_name) { 'BaseUri' }
      it { is_expected.to eq 'ExpectedSite' }
    end

    context 'when name is not existed' do
      let(:header_name) { 'Fragment' }
      it { is_expected.to eq nil }
    end
  end

  describe '.get_bool' do
    let(:header) { Tatami::Models::Csv::Header.new(:name => 'HttpRequest Expected', :depth => 2, :from => 1, :to => 3, :children => [
        Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 3, :from => 1, :to => 1),
        Tatami::Models::Csv::Header.new(:name => 'Fragment', :depth => 3, :from => 2, :to => 2)
    ])}
    let(:header_name) { 'Fragment' }
    let(:row) { ['case name', 'ExpectedSite', value] }

    subject { Tatami::Models::Csv::Header.get_bool(header, header_name, row) }

    context 'true' do
      let(:value) { 'true' }
      it { is_expected.to eq true }
    end

    context 'True' do
      let(:value) { 'True' }
      it { is_expected.to eq true }
    end

    context 'false' do
      let(:value) { 'false' }
      it { is_expected.to eq false }
    end

    context 'False' do
      let(:value) { 'False' }
      it { is_expected.to eq false }
    end

    context 'nil' do
      let(:value) { nil }
      it { is_expected.to eq false }
    end

    context 'empty' do
      let(:value) { '' }
      it { is_expected.to eq false }
    end

    context 'xxx' do
      let(:value) { 'xxx' }
      it { expect { subject }.to raise_error(Tatami::WrongFileFormatError, /Invalid Data Format/) }
    end
  end

  describe '.get_nullable_bool' do
    let(:header) { Tatami::Models::Csv::Header.new(:name => 'HttpRequest Expected', :depth => 2, :from => 1, :to => 3, :children => [
        Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 3, :from => 1, :to => 1),
        Tatami::Models::Csv::Header.new(:name => 'Fragment', :depth => 3, :from => 2, :to => 2)
    ])}
    let(:header_name) { 'Fragment' }
    let(:row) { ['case name', 'ExpectedSite', value] }

    subject { Tatami::Models::Csv::Header.get_nullable_bool(header, header_name, row) }

    context 'true' do
      let(:value) { 'true' }
      it { is_expected.to eq true }
    end

    context 'True' do
      let(:value) { 'True' }
      it { is_expected.to eq true }
    end

    context 'false' do
      let(:value) { 'false' }
      it { is_expected.to eq false }
    end

    context 'False' do
      let(:value) { 'False' }
      it { is_expected.to eq false }
    end

    context 'nil' do
      let(:value) { nil }
      it { is_expected.to eq nil }
    end

    context 'empty' do
      let(:value) { '' }
      it { is_expected.to eq nil }
    end

    context 'xxx' do
      let(:value) { 'xxx' }
      it { expect { subject }.to raise_error(Tatami::WrongFileFormatError, /Invalid Data Format/) }
    end
  end

  describe '.get_string_list' do
    let(:header) { Tatami::Models::Csv::Header.new(:name => 'HttpRequest Expected', :depth => 2, :from => 1, :to => 4, :children => [
        Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 3, :from => 1, :to => 1),
        Tatami::Models::Csv::Header.new(:name => 'PathInfo', :depth => 3, :from => 2, :to => 3),
        Tatami::Models::Csv::Header.new(:name => 'Fragment', :depth => 3, :from => 4, :to => 4)
    ])}
    subject { Tatami::Models::Csv::Header.get_string_list(header, 'PathInfo', row) }

    context 'when list is existed' do
      let(:row) { [ 'case name', 'ExpectedSite', 'pathInfo1', 'pathInfo2', nil ] }
      it { is_expected.to eq %w(pathInfo1 pathInfo2) }
    end
    context 'when list is not existed' do
      let(:row) { [ 'case name', 'ExpectedSite', nil, nil, nil ] }
      it { is_expected.to eq [] }
    end
  end

  describe '.get_hash' do
    let(:header) { Tatami::Models::Csv::Header.new(:name => 'HttpRequest Expected', :depth => 2, :from => 1, :to => 4, :children => [
        Tatami::Models::Csv::Header.new(:name => 'BaseUri', :depth => 3, :from => 1, :to => 1),
        Tatami::Models::Csv::Header.new(:name => 'Cookies', :depth => 3, :from => 2, :to => 3, :children => [
          Tatami::Models::Csv::Header.new(:name => 'cookie1', :depth => 4, :from => 2, :to => 2),
          Tatami::Models::Csv::Header.new(:name => 'cookie2', :depth => 4, :from => 3, :to => 3)
        ]),
        Tatami::Models::Csv::Header.new(:name => 'Fragment', :depth => 3, :from => 4, :to => 4)
    ])}
    subject { Tatami::Models::Csv::Header.get_hash(header, 'Cookies', row) }

    context 'when hash is existed' do
      let(:row) { [ 'case name', 'ExpectedSite', 'cookie1value', 'cookie2value', nil ] }
      it { is_expected.to include('cookie1' => 'cookie1value', 'cookie2' => 'cookie2value') }
    end
    context 'when hash is not existed' do
      let(:row) { ['case name', 'ExpectedSite', nil, nil, nil] }
      it { is_expected.to include }
    end
  end
end