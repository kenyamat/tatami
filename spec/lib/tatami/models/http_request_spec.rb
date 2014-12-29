RSpec.describe Tatami::Models::HttpRequest do
  describe '#to_s' do
    let(:sut) { Tatami::Models::HttpRequest.new(
        name: 'name',
        base_uri: 'base_uri',
        method: 'method',
        user_agent: 'user_agent',
        uri: 'uri',
        headers: 'headers',
        cookies: 'cookies',
        path_infos: 'path_infos',
        query_strings: 'query_strings',
        fragment: 'fragment',
        content: 'content'
    ) }
    subject { sut.to_s }
    it { is_expected.to eq 'name=name, base_uri=base_uri, method=method, user_agent=user_agent, uri=uri, headers=headers, cookies=cookies, path_infos=path_infos, query_strings=query_strings, fragment=fragment, content=content' }
  end
end