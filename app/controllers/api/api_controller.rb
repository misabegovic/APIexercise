module Api
  # Controller for Api side of this application
  class ApiController < ApplicationController
    before_action :check_header

    private

    def check_header
      if ['POST', 'PUT', 'PATCH'].include? request.method
        unless request.content_type == 'application/vnd.api+json'
          head :not_acceptable && return
        end
      end
    end

    def render_error(resource, status)
      render json: resource,
             status: status,
             adapter: :json_api,
             serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end
end
