# A client for Mapzen Search API
# https://mapzen.com/documentation/search/
module Mapzen
  class Search
    include HTTParty
    base_uri "search.mapzen.com/v1"

    SEARCH_API_PATH = "/search".freeze
    REVERSE_API_PATH = "/reverse".freeze
    AUTOCOMPLETE_API_PATH = "/autocomplete".freeze

    DEFAULT_OPTIONS = {
      "api_key" => ENV["MAPZEN_API_KEY"],
      "boundary.rect.min_lon" => -77.9830169678,
      "boundary.rect.max_lon" => -76.2341308594,
      "boundary.rect.min_lat" => 38.2646020963,
      "boundary.rect.max_lat" => 39.7198634855,
      "sources" => "osm,oa,wof",
      "layers" => "locality,county,neighbourhood,region"
    }.freeze

    # https://mapzen.com/documentation/search/autocomplete/
    def autocomplete(text)
      options = {
        query: {
          "text" => text,
          "size" => 10
        }.reverse_merge(DEFAULT_OPTIONS)
      }

      response = self.class.get(AUTOCOMPLETE_API_PATH, options)

      results = JSON.parse(response.body)
      labels = results["features"].map { |feature| feature.dig("properties", "label") }
      labels.map { |x| x.rpartition(", USA")[0] }
    end

    # https://mapzen.com/documentation/search/search/
    def search(text)
      options = {
        query: {
          "text" => text,
          "size" => 1
        }.reverse_merge(DEFAULT_OPTIONS)
      }

      response = self.class.get(SEARCH_API_PATH, options)

      results = JSON.parse(response.body)
      results["features"]&.first
    end

    # https://mapzen.com/documentation/search/reverse/
    def reverse_geocode(latitude, longitude)
      options = {
        query: {
          "point.lat" => latitude,
          "point.lon" => longitude,
          "size" => 1
        }.reverse_merge(DEFAULT_OPTIONS)
      }

      results = self.class.get(REVERSE_API_PATH, options)
      results["features"]&.first
    end
  end
end
