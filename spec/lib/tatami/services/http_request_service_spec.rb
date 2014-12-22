RSpec.describe Tatami::Services::HttpRequestService do
  let(:sut) { Tatami::Services::HttpRequestService.new }

  describe '#create_uri' do
    let(:base_uri) { 'http://a.com' }
    let(:path_infos) { nil }
    let(:query_strings) { nil }
    let(:fragment) {}
    subject { sut.create_uri(base_uri, path_infos, query_strings, fragment) }

    context 'path_infos' do
      context 'when path_info is found' do
        let(:path_infos) { %w(ab cd) }
        it { is_expected.to eq URI('http://a.com/ab/cd') }
      end

      context 'when path_info needs URI encode' do
        let(:path_infos) { ['a b', 'c d'] }
        it { is_expected.to eq URI('http://a.com/a+b/c+d') }
      end

      context 'when path_info is empty' do
        let(:path_infos) { [] }
        it { is_expected.to eq URI('http://a.com') }
      end
    end

    context 'query_strings' do
      context 'when query_strings is found' do
        let(:query_strings) { {'k1' => 'v1', 'k2' => 'v2'} }
        it { is_expected.to eq URI('http://a.com?k1=v1&k2=v2') }
      end

      context 'when query_strings needs URI encode' do
        let(:query_strings) { {'k 1' => 'v 1', 'k 2' => 'v 2'} }
        it { is_expected.to eq URI('http://a.com?k+1=v+1&k+2=v+2') }
      end

      context 'when query_strings is empty' do
        let(:query_strings) { Hash.new }
        it { is_expected.to eq URI('http://a.com') }
      end
    end

    context 'fragment' do
      context 'when fragment is found' do
        let(:fragment) { 'f' }
        it { is_expected.to eq URI('http://a.com#f') }
      end

      context 'when fragment needs URI encode' do
        let(:fragment) { 'f 1' }
        it { is_expected.to eq URI('http://a.com#f+1') }
      end
    end

    context 'all parameters' do
      context 'when all parameters' do
        let(:path_infos) { ['a b', 'c d'] }
        let(:query_strings) { {'k 1' => 'v 1', 'k 2' => 'v 2'} }
        let(:fragment) { 'f' }
        it { is_expected.to eq URI('http://a.com/a+b/c+d?k+1=v+1&k+2=v+2#f') }
      end

      context 'when no parameters' do
        it { is_expected.to eq URI('http://a.com') }
      end
    end
  end

  # TODO: more tests
  # describe '#get_response' do
  #   let(:proxy_uri) { 'http://localhost:8888' }
  #   let(:request) { Tatami::Models::HttpRequest.new(params)}
  #   let(:sut) {
  #     Tatami::Services::HttpRequestService.new(
  #         :base_uri_mapping => { 'yahoo' => 'http://weather.yahoo.co.jp' },
  #         :user_agent_mapping => { 'ie' => 'IE' },
  #         :proxy_uri => proxy_uri) }
  #
  #   subject { sut.get_response(request, nil, Proc.new { |r| p r }) }
  #
  #   context 'get' do
  #     let(:params) { {:base_uri => 'yahoo',
  #                     :method => 'DELETE',
  #                     :user_agent => 'ie',
  #                     :headers => { 'x-header' => 'test' },
  #                     :cookies => { 'c1' => 'cv1' },
  #                     :path_infos => %w(weather jp 13 4410.html),
  #                     :query_strings => { 'a' => 'b' },
  #                     :fragment => 'test',
  #                     :content => 'content' } }
  #     it { is_expected.to eq '' }
  #   end
  # end
end