RSpec.describe JsonApiQueryParser do
  it "has a version number" do
    expect(JsonApiQueryParser::VERSION).not_to be nil
  end

  it "returns correct resource_type and identifier hash" do
    expect(JsonApiQueryParser.parse_request("movies/5")).to be_instance_of(Hash)
    expect(JsonApiQueryParser.parse_request("movies/5")).to eq(resource_type: "movies", identifier: "5", query_data: { include: [], fields: {}, page: {} })
  end

  it "returns correct resource_type, identifier and includes hash" do
    expect(JsonApiQueryParser.parse_request("movies/5")).to be_instance_of(Hash)
    expect(JsonApiQueryParser.parse_request("movies/5?include=actors,actors.agency")).to eq(resource_type: "movies", identifier: "5", query_data: { include: ["actors", "actors.agency"], fields: {}, page: {} })
  end

  it "returns correct resource_type, identifier, includes and movie fields hash" do
    expect(JsonApiQueryParser.parse_request("movies/5")).to be_instance_of(Hash)
    expect(JsonApiQueryParser.parse_request("movies/5/?include=actors,actors.agency&fields[movies]=title,year")).to eq(resource_type: "movies", identifier: "5", query_data: { include: ["actors", "actors.agency"], fields: { "movies" => %w[title year] }, page: {} })
  end

  it "returns correct resource_type, identifier, includes, movie fields and actors fields hash" do
    expect(JsonApiQueryParser.parse_request("movies/5")).to be_instance_of(Hash)
    expect(JsonApiQueryParser.parse_request("movies/5/?include=actors,actors.agency&fields[movies]=title,year&fields[actors]=name")).to eq(resource_type: "movies", identifier: "5", query_data: { include: ["actors", "actors.agency"], fields: { "movies" => %w[title year], "actors" => ["name"] }, page: {} })
  end

  it "returns correct resource_type, identifier, includes, movie fields, actors fields and page limit hash" do
    expect(JsonApiQueryParser.parse_request("movies/5")).to be_instance_of(Hash)
    expect(JsonApiQueryParser.parse_request("movies/5/?include=actors,actors.agency&fields[movies]=title,year&fields[actors]=name&page[limit]=20")).to eq(resource_type: "movies", identifier: "5", query_data: { include: ["actors", "actors.agency"], fields: { "movies" => %w[title year], "actors" => ["name"] }, page: { "limit" => "20" } })
  end
end
