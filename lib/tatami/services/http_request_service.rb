module Tatami
  module Services
    class HttpRequestService
      attr_accessor :base_uri_mapping, :user_agent_mapping, :proxy_uri

      def initialize(params = nil)
        (params || []).each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end

      def create_uri(base_uri, path_infos = [], query_strings = [], fragment = nil)
        uri = path_infos ? URI.join(base_uri, path_infos.map { |v| url_encode(v) }.join('/')) : URI(base_uri)
        uri = URI.join(uri, '?' << query_strings.map { |k, v| url_encode(k) << '=' << url_encode(v) }.join('&')) if query_strings and query_strings.any?
        uri = URI.join(uri, '#' + url_encode(fragment)) if fragment and fragment != ''
        uri
      end

      def get_response(http_request, redirect_uri_str = nil, hook = nil, limit = 10)
        if redirect_uri_str
          request_uri = URI(redirect_uri_str)
        else
          base_uri = URI(@base_uri_mapping[http_request.base_uri])
          request_uri = create_uri(base_uri, http_request.path_infos, http_request.query_strings, http_request.fragment)
          http_request.uri = request_uri
        end

        headers = http_request.headers ||= {}
        headers['Cookie'] = http_request.cookies.map { |k, v| url_encode(k) + '=' + url_encode(v) }.join('; ') if http_request.cookies
        headers['User-Agent'] = user_agent_mapping[http_request.user_agent] if http_request.user_agent

        http_client = HTTPClient.new
        http_client.proxy = @proxy_uri if @proxy_uri

        response = get_request(http_client, http_request.method, request_uri, headers, http_request.content)
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

      def get_request(http_client, method, request_uri, headers, content)
        params = { :header => headers, :follow_redirect => true }
        params[:body] = content if content
        case method.to_s.upcase
          when 'DELETE' then
            http_client.delete(request_uri, params)
          when 'POST' then
            http_client.post(request_uri, params)
          when 'PUT' then
            http_client.put(request_uri, params)
          else
            http_client.get(request_uri, params)
        end
      end

      def url_encode(value)
        URI.encode_www_form_component(value)
      end
    end
  end
end