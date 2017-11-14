class ApplicationController < ActionController::API
  include RespondsWithError

  # Deliver errors in a single, unified format with clear, useful information.
  rescue_from ActiveRecord::RecordNotFound, with: :respond_with_not_found
end
