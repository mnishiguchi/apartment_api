require "geocoder/lookups/pelias"

# A custom Geocoder::Lookup class for Mapzen autocomplete api.
# https://mapzen.com/documentation/search/autocomplete/
# https://github.com/alexreisner/geocoder/blob/master/lib/geocoder/lookups/pelias.rb#L25

# Usage:
#
#   # https://github.com/alexreisner/geocoder/blob/master/lib/geocoder/lookups/base.rb#L45
#   r = Geocoder::Lookup::MapzenAutocomplete.new
#   r.search("Adams Morgan", params: {})
#
module Geocoder
  module Lookup
    class MapzenAutocomplete < Pelias
      # params hash must have symbol keys.
      DEFAULT_PARAMS = {
        "boundary.rect.min_lon": -77.9830169678,
        "boundary.rect.max_lon": -76.2341308594,
        "boundary.rect.min_lat": 38.2646020963,
        "boundary.rect.max_lat": 39.7198634855,
        sources: "osm,oa,wof",
        layers: "locality,county,neighbourhood,region",
        size: 10
      }.freeze

      def name
        "MapzenAutocomplete"
      end

      def endpoint
        configuration[:endpoint] || "search.mapzen.com"
      end

      def query_url(query)
        query_type = "autocomplete"
        "#{protocol}://#{endpoint}/v1/#{query_type}?" + url_query_string(query)
      end

      # Override super. Query the geocoding API and return an array of strings.
      # https://github.com/alexreisner/geocoder/blob/master/lib/geocoder/lookups/base.rb#L45
      def search(query, options = {})
        query = Geocoder::Query.new(query, options) unless query.is_a?(Geocoder::Query)
        results(query)
      end

      private

      # Convert user's query to params hash for this api. Take Geocoder::Query and return params hash.
      # https://github.com/alexreisner/geocoder/blob/master/lib/geocoder/lookups/pelias.rb#L25
      def query_url_params(query)
        # Create common params. Merge user-specified params hash into default params.
        params = DEFAULT_PARAMS.merge(super)
        params[:api_key] = configuration.api_key
        params[:text] = query.text
        params
      end

      # Fetch data for the specified Geocoder::Query instance and return results as an array of hashes.
      # When Geocoder::Lookup::MapzenSearch#search is called, that array will be converted into
      # an array of Geocoder::Result::MapzenSearch objects.
      # https://github.com/alexreisner/geocoder/blob/master/lib/geocoder/lookups/base.rb#L48
      # https://github.com/alexreisner/geocoder/blob/master/lib/geocoder/lookups/pelias.rb#L41
      def results(query)
        # An array of 'features' hashes or []
        features = super(query)
        features.
          map { |feature| feature.dig("properties", "label") }.
          map { |label| label.rpartition(", USA")[0] }
      end
    end
  end
end
