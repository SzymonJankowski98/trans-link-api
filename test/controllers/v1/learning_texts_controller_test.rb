# frozen_string_literal: true

require "test_helper"

module V1
  class LearningTextsControllerTest < ActionDispatch::IntegrationTest
    test "#index returns rearning texts" do
      resources = create_list(:learning_text, 3)

      get v1_learning_texts_path

      assert_response :ok
      assert_equal resources.pluck(:id), response.parsed_body["learning_texts"].pluck("id")
      assert_predicate resources_response_schema.call(response.parsed_body), :success?
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
