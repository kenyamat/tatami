module Tatami
  module Models
    class HttpRequest < ModelBase
      attr_accessor :name, :base_uri, :method, :user_agent, :uri,
        :headers, :cookies, :path_infos, :query_strings, :fragment, :content

      def to_s
        "name=#{@name}, base_uri=#{@base_uri}, method=#{@method}, user_agent=#{@user_agent}, uri=#{@uri}, headers=#{@headers}, cookies=#{@cookies}, path_infos=#{@path_infos}, query_strings=#{@query_strings}, fragment=#{@fragment}, content=#{@content}"
      end
    end
  end
end