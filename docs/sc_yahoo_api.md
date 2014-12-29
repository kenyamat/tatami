# Showcase: Yahoo API test

### Scenario : Test Web API which returns XML/JSON using static values.(Yahoo API)

* Test target : [Yahoo API](http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid=%222459115%22and%20u=%22f%22&format=xml)
* Sample Tests : spec\sample_implementation
* Test spreadsheet : [https://docs.google.com/spreadsheets/d/1h-8vkF-5jEHXDIBwUpA3_otRVa30Um6qm05ZYoSgbQg/edit?usp=sharing](https://docs.google.com/spreadsheets/d/1h-8vkF-5jEHXDIBwUpA3_otRVa30Um6qm05ZYoSgbQg/edit?usp=sharing)
* CSV download link : [https://docs.google.com/spreadsheets/d/1h-8vkF-5jEHXDIBwUpA3_otRVa30Um6qm05ZYoSgbQg/export?format=csv&id=1h-8vkF-5jEHXDIBwUpA3_otRVa30Um6qm05ZYoSgbQg&gid=0](https://docs.google.com/spreadsheets/d/1h-8vkF-5jEHXDIBwUpA3_otRVa30Um6qm05ZYoSgbQg/export?format=csv&id=1h-8vkF-5jEHXDIBwUpA3_otRVa30Um6qm05ZYoSgbQg&gid=0) 

### Test details
1. Get a actual JSON document from Web App (Yahoo API) 
1. Assert HTTP response header and/or document values using static values in CSV file.

![sample3](imgs/sample3.png)

* spec\sample_implementation\sample_implementation_spec.rb

```
RSpec.describe 'Sample implementation', :sample_implementation => true do
  let(:user_agent_mapping_xml) { File.read(File.join(File.dirname(__FILE__), 'settings/UserAgentMapping.xml'), :encoding => Encoding::UTF_8) }

  context 'Web API test (XML/JSON)' do
    let(:base_uri_mapping_xml) { File.read(File.join(File.dirname(__FILE__), 'settings/BaseUriMapping_YahooWeather.xml'), :encoding => Encoding::UTF_8) }
    it {
      test_case_url = 'https://docs.google.com/spreadsheets/d/15WbI7RpQZC-j--xsoYj7mfcapq96FsBi4ZVAEb_lroE/export?format=csv&id=15WbI7RpQZC-j--xsoYj7mfcapq96FsBi4ZVAEb_lroE&gid=0'
      test_cases_csv = HTTPClient.new.get_content(test_case_url).force_encoding('UTF-8')
      base_uri_mapping = Tatami::Parsers::Mappings::MappingParser.parse(base_uri_mapping_xml)
      user_agent_mapping = Tatami::Parsers::Mappings::MappingParser.parse(user_agent_mapping_xml)
      result = Tatami::TestExecutor.new(test_cases_csv, base_uri_mapping, user_agent_mapping).test
      puts result.get_failed_message
      expect(result.success?).to eq true
    }
  end
end

```