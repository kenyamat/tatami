# external libraries
require 'nokogiri'
require 'json'
require "active_support"
require 'active_support/core_ext'
require "active_support/all"

require 'tatami/version'

# constants
require 'tatami/constants/header_names'
require 'tatami/constants/parser_type'

# models
require 'tatami/models/arrange'
require 'tatami/models/http_request'

# parsers
require 'tatami/parsers/documents/xml_parser'
require 'tatami/parsers/documents/html_parser'
require 'tatami/parsers/documents/json_parser'