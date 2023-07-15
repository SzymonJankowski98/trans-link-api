# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  attr_reader :safe_params

  respond_to :json

  def render_errors(message, status: :unprocessable_entity)
    message = { base: [message] } if message.is_a? String

    render json: { errors: message }, status:
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
