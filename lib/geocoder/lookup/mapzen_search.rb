require "geocoder/lookups/pelias"

# A custom Geocoder::Lookup class for Mapzen search api.
# https://mapzen.com/documentation/search/
# https://github.com/alexreisner/geocoder/blob/master/lib/geocoder/lookups/pelias.rb#L25

# Usage:
#
#   # https://github.com/alexreisner/geocoder/blob/master/lib/geocoder/lookups/base.rb#L45
#   r = Geocoder::Lookup::Mapzen.new
#
#   # For geocoding, takes a search string and retutn an array of Geocoder::Result object
#   r.search("Adams Morgan", params: {})
#
#   # For reverse geocoding, coordinates (latitude, longitude) and retutn an array of Geocoder::Result object
#   r.search([38.9143795889, -77.0364987456], params: {})
#
module Geocoder
  module Lookup
    class MapzenSearch < Pelias
      # params hash must have symbol keys.
      DEFAULT_PARAMS = {
        "boundary.rect.min_lon": -77.9830169678,
        "boundary.rect.max_lon": -76.2341308594,
        "boundary.rect.min_lat": 38.2646020963,
        "boundary.rect.max_lat": 39.7198634855,
        sources: "osm,oa,wof",
        layers: "locality,county,neighbourhood,region",
        size: 1
      }.freeze

      def name
        "MapzenSearch"
      end

      def endpoint
        configuration[:endpoint] || "search.mapzen.com"
      end

      def query_url(query)
        query_type = query.reverse_geocode? ? "reverse" : "search"
        "#{protocol}://#{endpoint}/v1/#{query_type}?" + url_query_string(query)
      end

      # https://github.com/alexreisner/geocoder/blob/master/lib/geocoder/lookups/base.rb#L45
      def search(query, options = {})
        super(query, options)
      end

      private

      # Convert user's query to params hash for this api. Take Geocoder::Query and return params hash.
      # https://github.com/alexreisner/geocoder/blob/master/lib/geocoder/lookups/pelias.rb#L25
      def query_url_params(query)
        # Create common params. Merge user-specified params hash into default params.
        params = DEFAULT_PARAMS.merge(super)
        params[:api_key] = configuration.api_key

        if query.reverse_geocode?
          # For reverse geocoding api
          params[:'point.lat'] = query.coordinates[0]
          params[:'point.lon'] = query.coordinates[1]
        else
          # For search api
          params[:text] = query.text
        end

        params
      end

      # Fetch data for the specified Geocoder::Query instance and return results as an array of hashes.
      # When Geocoder::Lookup::MapzenSearch#search is called, that array will be converted into
      # an array of Geocoder::Result::MapzenSearch objects.
      # https://github.com/alexreisner/geocoder/blob/master/lib/geocoder/lookups/pelias.rb#L41
      # def results(query)
      #   # An array of 'features' hashes or []
      #   super(query)
      # end
    end
  end
end
