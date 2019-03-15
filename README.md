# JSON API query parser

[![Gem Version](https://badge.fury.io/rb/json_api_query_parser.svg)](https://badge.fury.io/rb/json_api_query_parser) [![Build Status](https://travis-ci.org/g13ydson/json_api_query_parser.svg?branch=master)](https://travis-ci.org/g13ydson/json_api_query_parser) [![Maintainability](https://api.codeclimate.com/v1/badges/c29beeab2c474cbe15d0/maintainability)](https://codeclimate.com/github/g13ydson/json_api_query_parser/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/c29beeab2c474cbe15d0/test_coverage)](https://codeclimate.com/github/g13ydson/json_api_query_parser/test_coverage)

To be used for ruby projects that make use of [JSON API](http://jsonapi.org/)


## Installation

```sh
$ gem install json_api_query_parser
```

Or in the gemfile of the rails project

```ruby
gem 'json_api_query_parser'
```

## Usage

Require the gem 'json_api_query_parser' into your application and use the 'parse_request' method to convert the request.url to an easy
usable Hash.

```ruby
require('json_api_query_parser')
JsonApiQueryParser.parse_request("movies/5?include=actors,actors.agency&fields[movies]=title,year&fields[actors]=name&page[limit]=20")
```

## Return data information

The Hash returned by the JsonApiQueryParser.parse_request will always be the same structure.

```ruby
{
  :resource_type=>"movies", 
  :identifier=>"5", 
  :query_data=>{
    :include=>["actors", "actors.agency"], 
    :fields=>{:movies=>["title", "year"], :actors=>["name"]},
    :page=>{"limit"=>"20"}
  }
} 
```
