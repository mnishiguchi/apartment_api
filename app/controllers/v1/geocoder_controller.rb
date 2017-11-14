class V1::GeocoderController < ApplicationController
  def autocomplete
    result = Geocoder.search(params[:location], autocomplete: true)
    log_search_result(result)
    render json: result.data, status: :ok
  end

  def search
    result = Geocoder.search(params[:location])
    log_search_result(result)
    render json: result.data, status: :ok
  end

  def reverse
    result = Geocoder.search([params[:latitude], params[:longitude]])
    log_search_result(result)
    render json: result.data, status: :ok
  end

  private

  def log_search_result(result)
    msg = <<~MSG
      cache_hit: #{result.cache_hit ? true : false}
      data: #{result.data}
    MSG
    logger.info(msg)
  end
end
