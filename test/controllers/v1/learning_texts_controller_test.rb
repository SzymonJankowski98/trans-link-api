# frozen_string_literal: true

require "test_helper"

module V1
  class LearningTextsControllerTest < ActionDispatch::IntegrationTest
    test "#index returns learning texts" do
      resources = create_list(:learning_text, 3).reverse

      get v1_learning_texts_path(params: { page: 1, extra_param: 1 })

      assert_response :ok
      assert_equal resources.pluck(:id), response.parsed_body["learning_texts"].pluck("id")
      assert_predicate resources_response_schema.call(response.parsed_body), :success?
    end

    test "#index returns error when params are invalid" do
      resources = create_list(:learning_text, 3).reverse

      get v1_learning_texts_path(params: { page: "one" })

      assert_response :bad_request

      expected_error = { "errors" => { "page" => ["must be an integer"] } }

      assert_equal expected_error, response.parsed_body
    end

    private

    def resources_response_schema
      Dry::Schema.Params do
        required(:learning_texts).array(:hash).schema do
          Schemas::LearningText::SCHEMA
        end
      end
    end
  end
end
