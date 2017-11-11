# A client for Mapzen Places API
# https://mapzen.com/documentation/places/
module Mapzen
  class Places
    include HTTParty
    base_uri "places.mapzen.com/v1"

    DEFAULT_OPTIONS = {
      "api_key" => ENV["MAPZEN_API_KEY"],
      "boundary.rect.min_lon" => -77.9830169678,
      "boundary.rect.max_lon" => -76.2341308594,
      "boundary.rect.min_lat" => 38.2646020963,
      "boundary.rect.max_lat" => 39.7198634855
    }.freeze

    # https://mapzen.com/documentation/places/methods/#mapzenplacessourcesgetinfo
    def get_info(id)
      options = {
        query: {
          "method" => "mapzen.places.sources.getInfo",
          "id" => id,
          "size" => 1
        }.reverse_merge(DEFAULT_OPTIONS)
      }

      response = self.class.get("/", options)

      results = JSON.parse(response.body)
      results["source"]
    end
  end
end
