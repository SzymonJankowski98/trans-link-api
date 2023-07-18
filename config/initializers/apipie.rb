# frozen_string_literal: true

Apipie.configure do |config|
  config.app_name                = "TransLinkApi"
  config.api_base_url            = "/v1"
  config.doc_base_url            = "/api_docs"
  config.api_controllers_matcher = Rails.root.join("/app/controllers/**/*.rb")

  config.validate = false
end
