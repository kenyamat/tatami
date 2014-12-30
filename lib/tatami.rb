# external libraries
require 'nokogiri'
require 'json'
require "active_support"
require 'active_support/core_ext'
require 'uri'
require 'httpclient'
require 'csv_parser'

# version
require 'tatami/version'

# constants
require 'tatami/constants/header_names'
require 'tatami/constants/parser_type'

# models
require 'tatami/models/model_base'
require 'tatami/models/arrange'
require 'tatami/models/arranges'
require 'tatami/models/http_request'
require 'tatami/models/http_response'
require 'tatami/models/assertions/assertion_base'
require 'tatami/models/assertions/content_assertion_item'
require 'tatami/models/assertions/cookie_assertion'
require 'tatami/models/assertions/text_assertion'
require 'tatami/models/assertions/datetime_assertion'
require 'tatami/models/assertions/header_assertion'
require 'tatami/models/assertions/uri_assertion'
require 'tatami/models/assertions/status_code_assertion'
require 'tatami/models/assertions/xsd_assertion'
require 'tatami/models/test_case'
require 'tatami/models/test_cases'
require 'tatami/models/csv/header'

# services
require 'tatami/services/http_request_service'

# parsers
require 'tatami/parsers/wrong_file_format_error'
require 'tatami/parsers/mappings/mapping_parser'
require 'tatami/parsers/documents/xml_parser'
require 'tatami/parsers/documents/html_parser'
require 'tatami/parsers/documents/json_parser'
require 'tatami/parsers/documents/text_parser'
require 'tatami/parsers/csv/assertions/content_assertion_parser'
require 'tatami/parsers/csv/assertions/headers_assertion_parser'
require 'tatami/parsers/csv/assertions/cookies_assertion_parser'
require 'tatami/parsers/csv/assertions/text_assertion_parser'
require 'tatami/parsers/csv/assertions/datetime_assertion_parser'
require 'tatami/parsers/csv/assertions/xsd_assertion_parser'
require 'tatami/parsers/csv/assertions/uri_assertion_parser'
require 'tatami/parsers/csv/assertions/status_code_assertion_parser'
require 'tatami/parsers/csv/assertions/assertions_parser'
require 'tatami/parsers/csv/http_request_parser'
require 'tatami/parsers/csv/arranges_parser'
require 'tatami/parsers/csv/header_parser'
require 'tatami/parsers/csv/test_case_parser'
require 'tatami/parsers/csv/test_cases_parser'

# validator
require 'tatami/validators/csv/header_validator'

# executor
require 'tatami/test_executor'