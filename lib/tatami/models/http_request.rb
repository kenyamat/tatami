module Tatami
  module Models
    class HttpRequest
      attr_accessor :name, :base_uri, :method, :user_agent, :uri,
        :headers, :cookies, :path_infos, :query_strings, :fragment, :content
    end
  end
end