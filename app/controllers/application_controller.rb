# frozen_string_literal: true

module ActiveRecord
  class RescuableRecordNotFound < ActiveRecord::RecordNotFound; end
end

class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  respond_to :json
  rescue_from ActiveRecord::RescuableRecordNotFound, with: :render_not_found

  attr_reader :safe_params

  def render_errors(message, status: :unprocessable_entity)
    message = { base: [message] } if message.is_a? String

    render json: { errors: message }, status:
  end

  def render_not_found
    render_errors("Not found", status: :not_found)
  end

  def rescuable_find(model, id)
    model.find(id)
  rescue ActiveRecord::RecordNotFound
    raise ActiveRecord::RescuableRecordNotFound
  end

  def validate_params!(schema = nil)
    schema ||= action_schema
    validated_params = schema.new.call(params.to_unsafe_hash)

    if validated_params.failure?
      return render_errors(validated_params.errors.to_h, status: :bad_request) # rubocop:disable Rails/DeprecatedActiveModelErrorsMethods
    end

    @safe_params = validated_params.to_h
  end

  private

  def action_schema
    "::#{controller_name.camelize}::#{action_name.camelize}Schema".constantize
  end
end
