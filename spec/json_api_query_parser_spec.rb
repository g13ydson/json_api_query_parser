RSpec.describe JsonApiQueryParser do
  it "has a version number" do
    expect(JsonApiQueryParser::VERSION).not_to be nil
  end

  it "returns correct resourceType and identifier hash" do
    expect(JsonApiQueryParser.parseRequest("movies/5")).to be_instance_of(Hash)
    expect(JsonApiQueryParser.parseRequest("movies/5")).to eq(resourceType: "movies", identifier: "5", queryData: { include: [], fields: {}, page: {} })
  end

  it "returns correct resourceType, identifier and includes hash" do
    expect(JsonApiQueryParser.parseRequest("movies/5")).to be_instance_of(Hash)
    expect(JsonApiQueryParser.parseRequest("movies/5?include=actors,actors.agency")).to eq(resourceType: "movies", identifier: "5", queryData: { include: ["actors", "actors.agency"], fields: {}, page: {} })
  end

  it "returns correct resourceType, identifier, includes and movie fields hash" do
    expect(JsonApiQueryParser.parseRequest("movies/5")).to be_instance_of(Hash)
    expect(JsonApiQueryParser.parseRequest("movies/5/?include=actors,actors.agency&fields[movies]=title,year")).to eq(resourceType: "movies", identifier: "5", queryData: { include: ["actors", "actors.agency"], fields: { "movies" => %w[title year] }, page: {} })
  end

  it "returns correct resourceType, identifier, includes, movie fields and actors fields hash" do
    expect(JsonApiQueryParser.parseRequest("movies/5")).to be_instance_of(Hash)
    expect(JsonApiQueryParser.parseRequest("movies/5/?include=actors,actors.agency&fields[movies]=title,year&fields[actors]=name")).to eq(resourceType: "movies", identifier: "5", queryData: { include: ["actors", "actors.agency"], fields: { "movies" => %w[title year], "actors" => ["name"] }, page: {} })
  end

  it "returns correct resourceType, identifier, includes, movie fields, actors fields and page limit hash" do
    expect(JsonApiQueryParser.parseRequest("movies/5")).to be_instance_of(Hash)
    expect(JsonApiQueryParser.parseRequest("movies/5/?include=actors,actors.agency&fields[movies]=title,year&fields[actors]=name&page[limit]=20")).to eq(resourceType: "movies", identifier: "5", queryData: { include: ["actors", "actors.agency"], fields: { "movies" => %w[title year], "actors" => ["name"] }, page: { "limit" => "20" } })
  end
end
