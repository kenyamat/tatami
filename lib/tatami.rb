# external libraries
require 'nokogiri'
require 'json'
require "active_support"
require 'active_support/core_ext'

require 'tatami/version'

# constants
require 'tatami/constants/header_names'
require 'tatami/constants/parser_type'

# models
require 'tatami/models/arrange'
require 'tatami/models/http_request'
require 'tatami/models/http_response'

# parsers
require 'tatami/parsers/documents/xml_parser'
require 'tatami/parsers/documents/html_parser'
require 'tatami/parsers/documents/json_parser'
require 'tatami/parsers/documents/text_parser'