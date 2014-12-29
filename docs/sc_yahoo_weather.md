# Showcase: Yahoo Weather page test

### Scenario : Test a HTML structure of "New York" page using values from Web API (Yahoo Weather RSS).
Recent Web applications consume data created by Web API instead of database. This scenario will cover to test values between HTML and XML from Web API.     

* Test target : [http://weather.yahoo.com/united-states/new-york/new-york-2459115/](http://weather.yahoo.com/united-states/new-york/new-york-2459115/)
* Test expected value : [http://weather.yahooapis.com/forecastrss?w=2459115](http://weather.yahooapis.com/forecastrss?w=2459115)
* Sample Tests : spec\sample_implementation 
* Test spreadsheet : [https://docs.google.com/spreadsheets/d/15WbI7RpQZC-j--xsoYj7mfcapq96FsBi4ZVAEb_lroE/edit?usp=sharing](https://docs.google.com/spreadsheets/d/15WbI7RpQZC-j--xsoYj7mfcapq96FsBi4ZVAEb_lroE/edit?usp=sharing)
* CSV download link: [https://docs.google.com/spreadsheets/d/15WbI7RpQZC-j--xsoYj7mfcapq96FsBi4ZVAEb_lroE/export?format=csv&id=15WbI7RpQZC-j--xsoYj7mfcapq96FsBi4ZVAEb_lroE&gid=0](https://docs.google.com/spreadsheets/d/15WbI7RpQZC-j--xsoYj7mfcapq96FsBi4ZVAEb_lroE/export?format=csv&id=15WbI7RpQZC-j--xsoYj7mfcapq96FsBi4ZVAEb_lroE&gid=0) 

### Test details
1. Get a expected XML document from Web API (Yahoo Weather RSS)
1. Get a actual html document from Web App (Yahoo Weather New youk page) 
1. Assert HTTP response header and/or document values using expected values in XML or CSV file.

![sample2](imgs/sample2.png)

* spec\sample_implementation\sample_implementation_spec.rb

```
RSpec.describe 'Sample implementation', :sample_implementation => true do
  let(:user_agent_mapping_xml) { File.read(File.join(File.dirname(__FILE__), 'settings/UserAgentMapping.xml'), :encoding => Encoding::UTF_8) }

  context 'HTML page test using Web API (Yahoo Weather)' do
    let(:base_uri_mapping_xml) { File.read(File.join(File.dirname(__FILE__), 'settings/BaseUriMapping_YahooApi.xml'), :encoding => Encoding::UTF_8) }
    it {
      test_case_url = 'https://docs.google.com/spreadsheets/d/1h-8vkF-5jEHXDIBwUpA3_otRVa30Um6qm05ZYoSgbQg/export?format=csv&id=1h-8vkF-5jEHXDIBwUpA3_otRVa30Um6qm05ZYoSgbQg&gid=0'
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