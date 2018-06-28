require "json_api_query_parser/version"

module JsonApiQueryParser
  PARSE_PARAM = {
    parseInclude: /^include\=(.*?)/i,
    parseFields: /^fields\[(.*?)\]\=.*?$/i
  }.freeze

  def self.parseRequest(url)
    requestData = {
      resourceType: nil,
      identifier: nil,
      queryData: {
        include: [],
        fields: {}
      }
    }

    urlSplit = url.split("?")
    requestData = parseEndpoint(urlSplit[0], requestData)

    if urlSplit[1]
      requestData[:queryData] = parseQueryParameters(urlSplit[1], requestData[:queryData])
    end

    requestData
  end

  def self.parseQueryParameters(queryString, requestDataSubset)
    querySplit = queryString.split("&")

    querySplit.each do |query|
      delegateToParser(query, requestDataSubset)
    end

    requestDataSubset
  end

  def self.trimSlashes(input)
    slashPattern = "/(^\/)|(\/$)/"
    trimmed = input.gsub(slashPattern, "")

    if slashPattern.match(trimmed)
      JsonApiQueryParser.trimSlashes(trimmed)
    else
      trimmed
    end
  end

  def self.parseEndpoint(endpointString, requestObject)
    requestSplit = JsonApiQueryParser.trimSlashes(endpointString).split("/")

    requestObject[:resourceType] = requestSplit[0]
    requestObject[:identifier] = (requestSplit.length >= 2 ? requestSplit[1] : nil)

    requestObject
  end

  def self.delegateToParser(query, requestDataSubset)
    PARSE_PARAM.each do |functionName, _value|
      if query =~ PARSE_PARAM[functionName.to_sym]
        requestDataSubset = send(functionName, query, requestDataSubset)
      end
    end
  end

  def self.parseInclude(includeString, requestDataSubset)
    targetString = includeString.split("=")[1]
    requestDataSubset[:include] = targetString.split(",")

    requestDataSubset
  end

  def self.parseFields(fieldsString, requestDataSubset)
    targetResource, targetFields, targetFieldsString = ""
    fieldNameRegex = /^fields.*?\=(.*?)$/i

    targetResource = fieldsString.scan(PARSE_PARAM[:parseFields])

    targetFieldsString = fieldsString.scan(fieldNameRegex)

    requestDataSubset[:fields][targetResource[0][0].to_sym] = !requestDataSubset[:fields][targetResource[0][0].to_sym] ? [] : targetResource[0][0].to_sym
    targetFields = targetFieldsString[0][0].split(",")

    targetFields.each do |targetField|
      requestDataSubset[:fields][targetResource[0][0].to_sym] << targetField
    end

    requestDataSubset
  end
end
