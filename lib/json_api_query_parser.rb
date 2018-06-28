# frozen_string_literal: true

require "json_api_query_parser/version"

module JsonApiQueryParser
  PARSE_PARAM = {
    parseInclude: /^include\=(.*?)/i,
    parseFields: /^fields\[(.*?)\]\=.*?$/i,
    parsePage: /^page\[(.*?)\]\=.*?$/i
  }.freeze

  def self.parseRequest(url)
    requestData = {
      resourceType: nil,
      identifier: nil,
      queryData: {
        include: [],
        fields: {},
        page: {}
      }
    }

    urlSplit = url.split("?")
    requestData = parseEndpoint(urlSplit[0], requestData) if urlSplit[0]

    if urlSplit[1]
      requestData[:queryData] = parseQueryParameters(urlSplit[1], requestData[:queryData])
    end

    requestData
  end

  def self.parseQueryParameters(queryString, requestData)
    querySplit = queryString.split("&")

    querySplit.each do |query|
      delegateToParser(query, requestData)
    end

    requestData
  end

  def self.parseEndpoint(endpointString, requestData)
    requestSplit = endpointString.split("/")

    requestData[:resourceType] = requestSplit[0]
    requestData[:identifier] = (requestSplit.length >= 2 ? requestSplit[1] : nil)

    requestData
  end

  def self.delegateToParser(query, requestData)
    PARSE_PARAM.each do |functionName, _value|
      if query =~ PARSE_PARAM[functionName.to_sym]
        requestData = send(functionName, query, requestData)
      end
    end
  end

  def self.parseInclude(includeString, requestData)
    targetString = includeString.split("=")[1]
    requestData[:include] = targetString.split(",")

    requestData
  end

  def self.parseFields(fieldsString, requestData)
    targetResource, targetFields, targetFieldsString = ""
    fieldNameRegex = /^fields.*?\=(.*?)$/i

    targetResource = fieldsString.scan(PARSE_PARAM[:parseFields])

    targetFieldsString = fieldsString.scan(fieldNameRegex)

    requestData[:fields][targetResource[0][0]] = !requestData[:fields][targetResource[0][0]] ? [] : targetResource[0][0]
    targetFields = targetFieldsString[0][0].split(",")

    targetFields.each do |targetField|
      requestData[:fields][targetResource[0][0]] << targetField
    end

    requestData
  end

  def self.parsePage (pageString, requestData)
    pageSettingKey, pageSettingValue = ""
    pageValueRegex = /^page.*?\=(.*?)$/i

    pageSettingKey = pageString.scan(PARSE_PARAM[:parsePage])

    pageSettingValue = pageString.scan(pageValueRegex)

    requestData[:page][pageSettingKey[0][0]] = pageSettingValue[0][0]

    requestData
  end
end
