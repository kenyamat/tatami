RSpec.describe 'Sample implementation', :sample_implementation => true do
  context 'HTML page test (Wikipedia)' do
    it {
      test_case_url = 'https://docs.google.com/spreadsheets/d/1Gvnq2NlBXyrnsjBH0Xr-R8U0f9RLeCR9RH5eAdTL_XE/export?format=csv&id=1Gvnq2NlBXyrnsjBH0Xr-R8U0f9RLeCR9RH5eAdTL_XE&gid=0'
      test_cases_csv = HTTPClient.new.get_content(test_case_url).force_encoding('UTF-8')
      base_uri_mapping = Tatami::Parsers::Mappings::MappingParser.parse(File.join(File.dirname(__FILE__), 'settings/BaseUriMapping_Wikipedia.xml'))
      user_agent_mapping = Tatami::Parsers::Mappings::MappingParser.parse(File.join(File.dirname(__FILE__), 'settings/UserAgentMapping.xml'))
      result = Tatami::TestExecutor.new(test_cases_csv, base_uri_mapping, user_agent_mapping).test
      puts result.get_failed_message
      expect(result.success?).to eq true
    }
  end

  context 'HTML page test using Web API (Yahoo Weather)' do
    it {
      test_case_url = 'https://docs.google.com/spreadsheets/d/1h-8vkF-5jEHXDIBwUpA3_otRVa30Um6qm05ZYoSgbQg/export?format=csv&id=1h-8vkF-5jEHXDIBwUpA3_otRVa30Um6qm05ZYoSgbQg&gid=0'
      test_cases_csv = HTTPClient.new.get_content(test_case_url).force_encoding('UTF-8')
      base_uri_mapping = Tatami::Parsers::Mappings::MappingParser.parse(File.join(File.dirname(__FILE__), 'settings/BaseUriMapping_YahooApi.xml'))
      user_agent_mapping = Tatami::Parsers::Mappings::MappingParser.parse(File.join(File.dirname(__FILE__), 'settings/UserAgentMapping.xml'))
      result = Tatami::TestExecutor.new(test_cases_csv, base_uri_mapping, user_agent_mapping).test
      puts result.get_failed_message
      expect(result.success?).to eq true
    }
  end

  context 'Web API test (XML/JSON)' do
    it {
      test_case_url = 'https://docs.google.com/spreadsheets/d/15WbI7RpQZC-j--xsoYj7mfcapq96FsBi4ZVAEb_lroE/export?format=csv&id=15WbI7RpQZC-j--xsoYj7mfcapq96FsBi4ZVAEb_lroE&gid=0'
      test_cases_csv = HTTPClient.new.get_content(test_case_url).force_encoding('UTF-8')
      base_uri_mapping = Tatami::Parsers::Mappings::MappingParser.parse(File.join(File.dirname(__FILE__), 'settings/BaseUriMapping_YahooWeather.xml'))
      user_agent_mapping = Tatami::Parsers::Mappings::MappingParser.parse(File.join(File.dirname(__FILE__), 'settings/UserAgentMapping.xml'))
      result = Tatami::TestExecutor.new(test_cases_csv, base_uri_mapping, user_agent_mapping).test
      puts result.get_failed_message
      expect(result.success?).to eq true
    }
  end
end