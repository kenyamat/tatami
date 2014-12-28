module Tatami
  class TestExecutor
    attr_accessor :expected_request_hook, :actual_request_hook

    def initialize(test_case_csv, base_uri_mapping, user_agent_mapping = nil, proxy_uri = nil)
      raise ArgumentError, 'test_case_csv must not be nil.' if test_case_csv.to_s.strip == ''
      raise ArgumentError, 'base_uri_mapping must not be empty.' if base_uri_mapping.empty?
      @test_case_csv = test_case_csv
      @base_uri_mapping = base_uri_mapping
      @user_agent_mapping = user_agent_mapping
      @proxy_uri = proxy_uri
      @expected_request_hook ||= nil
      @actual_request_hook ||= nil
    end

    def test
      csv_parser = CsvParser::Parser.new
      test_cases = Tatami::Parsers::Csv::TestCasesParser.parse(csv_parser.parse(@test_case_csv))
      http_request_service = Tatami::Services::HttpRequestService.new(
          :base_uri_mapping => @base_uri_mapping,
          :user_agent_mapping => @user_agent_mapping,
          :proxy_uri => @proxy_uri)
      test_cases.test(http_request_service, @expected_request_hook, @actual_request_hook)
      test_cases
    end
  end
end