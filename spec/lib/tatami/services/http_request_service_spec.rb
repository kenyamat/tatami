RSpec.describe Tatami::Services::HttpRequestService do
  let(:http_client) { spy('http_client') }
  let(:base_uri_mapping) { nil }
  let(:user_agent_mapping) { nil }
  let(:sut) { Tatami::Services::HttpRequestService.new(http_client, base_uri_mapping, user_agent_mapping) }

  describe '#get_response' do
    let(:base_uri_mapping) { { 'test' => 'http://a.com' } }
    let(:http_request) { Tatami::Models::HttpRequest.new(base_uri: 'test') }
    subject { sut.get_response(http_request) }

    context 'when valid' do
      let(:response) { double(:content => '<html><body>a</body></html>',
                              :status => 200,
                              :http_header => double(:request_uri => 'http://b.com'),
                              :content_type => 'text/html',
                              :headers => { 'h1' => 'h1v', 'h2' => 'h2v' },
                              :cookies => [ double(:name => 'c1', :value => 'c1v'), double(:name => 'c2', :value => 'c2v') ]) }
      it {
        allow(http_client).to receive(:get).and_return(response)
        expect(subject.contents).to eq '<html><body>a</body></html>'
        expect(subject.status_code).to eq 200
        expect(subject.uri).to eq 'http://b.com'
        expect(subject.content_type).to eq 'text/html'
        expect(subject.headers).to eq({ 'h1' => 'h1v', 'h2' => 'h2v' })
        expect(subject.cookies).to eq({ 'c1' => 'c1v', 'c2' => 'c2v' })
      }
    end
  end

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

  describe '#create_headers' do
    let(:headers) { nil }
    let(:cookies) { nil }
    let(:user_agent) { nil }
    let(:http_request) { Tatami::Models::HttpRequest.new(headers: headers, cookies: cookies, user_agent: user_agent) }
    subject { sut.create_headers(http_request) }

    context 'when headers is empty' do
      it { is_expected.to eq({}) }
    end

    context 'when there is all values' do
      let(:headers) { { 'h1' => 'h1v' } }
      let(:cookies) { { 'c1' => 'c1v' } }
      let(:user_agent_mapping) { { 'IE10' => 'Mozilla/5.0'} }
      let(:user_agent) { 'IE10' }
      it { is_expected.to eq({ "h1" => "h1v", "Cookie" => "c1=c1v", "User-Agent" => "Mozilla/5.0" }) }
    end
  end

  describe '#execute_request' do
    let(:method) { nil }
    let(:request_uri) { 'http://a.com' }
    let(:headers) { {} }
    let(:content) { 'test' }
    let(:params) { {:body => content, :header => headers, :follow_redirect => true } }
    before { sut.execute_request(method, request_uri, headers, content) }

    context 'GET' do
      let(:method) { 'get' }
      it { expect(http_client).to have_received(:get).with(request_uri, params) }
    end

    context 'POST' do
      let(:method) { 'post' }
      it { expect(http_client).to have_received(:post).with(request_uri, params) }
    end

    context 'PUT' do
      let(:method) { 'put' }
      it { expect(http_client).to have_received(:put).with(request_uri, params) }
    end

    context 'DELETE' do
      let(:method) { 'delete' }
      it { expect(http_client).to have_received(:delete).with(request_uri, params) }
    end
  end
end