# frozen_string_literal: true

require "json_api_query_parser/version"

module JsonApiQueryParser
  PARSE_PARAM = {
    parse_include: /^include\=(.*?)/i,
    parse_fields: /^fields\[(.*?)\]\=.*?$/i,
    parse_page: /^page\[(.*?)\]\=.*?$/i
  }.freeze

  def self.parse_request(url)
    request_data = {
      resource_type: nil,
      identifier: nil,
      query_data: {
        include: [],
        fields: {},
        page: {}
      }
    }

    url_split = url.split("?")
    request_data = parse_endpoint(url_split[0], request_data) if url_split[0]

    if url_split[1]
      request_data[:query_data] = parse_query_parameters(url_split[1], request_data[:query_data])
    end

    request_data
  end

  def self.parse_query_parameters(query_string, request_data)
    query_split = query_string.split("&")

    query_split.each do |query|
      delegate_to_parser(query, request_data)
    end

    request_data
  end

  def self.parse_endpoint(endpoint_string, request_data)
    request_split = endpoint_string.split("/")

    request_data[:resource_type] = request_split[0]
    request_data[:identifier] = request_split.length >= 2 ? request_split[1] : nil

    request_data
  end

  def self.delegate_to_parser(query, request_data)
    PARSE_PARAM.each do |function_name, _value|
      if query =~ PARSE_PARAM[function_name.to_sym]
        request_data = send(function_name, query, request_data)
      end
    end
  end

  def self.parse_include(include_string, request_data)
    target_string = include_string.split("=")[1]
    request_data[:include] = target_string.split(",")

    request_data
  end

  def self.parse_fields(fields_string, request_data)
    target_resource, target_fields, target_fields_string = ""
    field_name_regex = /^fields.*?\=(.*?)$/i

    target_resource = fields_string.scan(PARSE_PARAM[:parse_fields])

    target_fields_string = fields_string.scan(field_name_regex)

    request_data[:fields][target_resource[0][0]] = !request_data[:fields][target_resource[0][0]] ? [] : target_resource[0][0]
    target_fields = target_fields_string[0][0].split(",")

    target_fields.each do |targetField|
      request_data[:fields][target_resource[0][0]] << targetField
    end

    request_data
  end

  def self.parse_page (page_string, request_data)
    page_setting_key, page_setting_value = ""
    page_value_regex = /^page.*?\=(.*?)$/i

    page_setting_key = page_string.scan(PARSE_PARAM[:parse_page])

    page_setting_value = page_string.scan(page_value_regex)

    request_data[:page][page_setting_key[0][0]] = page_setting_value[0][0]

    request_data
  end
end
