# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  respond_to :json

  def render_errors(message, status: :unprocessable_entity)
    message = { base: [message] } if message.is_a? String

    render json: { errors: message }, status:
  end
end
