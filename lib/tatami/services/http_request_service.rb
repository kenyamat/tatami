module Tatami
  module Services
    class HttpRequestService
      attr_accessor :http_client, :base_uri_mapping, :user_agent_mapping

      def initialize(http_client, base_uri_mapping, user_agent_mapping = nil)
        @http_client = http_client
        @base_uri_mapping = base_uri_mapping
        @user_agent_mapping = user_agent_mapping
      end

      def get_response(http_request, hook = nil)
        base_uri = URI(@base_uri_mapping[http_request.base_uri])
        request_uri = create_uri(base_uri, http_request.path_infos, http_request.query_strings, http_request.fragment)
        http_request.uri = request_uri
        response = execute_request(http_request.method, request_uri, create_headers(http_request), http_request.content)
        http_response = Tatami::Models::HttpResponse.new(
            :contents => response.content,
            :status_code => response.status,
            :uri => response.http_header.request_uri.to_s,
            :content_type => response.content_type,
            :headers => response.headers,
            :cookies => response.cookies ? Hash[response.cookies.map { |c| [c.name, c.value] }] : {} # ruby2.1~ response.cookies.map { |c| [c.name, c.value] }.to_h)
        )
        http_response
      end

      def create_uri(base_uri, path_infos = [], query_strings = [], fragment = nil)
        uri = path_infos ? URI.join(base_uri, path_infos.map { |v| encode_url(v) }.join('/')) : URI(base_uri)
        uri = URI.join(uri, '?' << query_strings.map { |k, v| encode_url(k) << '=' << encode_url(v) }.join('&')) if query_strings and query_strings.any?
        uri = URI.join(uri, '#' + encode_url(fragment)) if fragment and fragment != ''
        uri
      end

      def create_headers(http_request)
        headers = http_request.headers ||= {}
        headers['Cookie'] = http_request.cookies.map { |k, v| encode_url(k) + '=' + encode_url(v) }.join('; ') if http_request.cookies
        headers['User-Agent'] = user_agent_mapping[http_request.user_agent] if http_request.user_agent
        headers
      end

      def execute_request(method, request_uri, headers, content)
        params = { :header => headers, :follow_redirect => true }
        params[:body] = content if content
        case method.to_s.upcase
          when 'DELETE' then
            @http_client.delete(request_uri, params)
          when 'POST' then
            @http_client.post(request_uri, params)
          when 'PUT' then
            @http_client.put(request_uri, params)
          else
            @http_client.get(request_uri, params)
        end
      end

      def encode_url(value)
        URI.encode_www_form_component(value)
      end
    end
  end
end