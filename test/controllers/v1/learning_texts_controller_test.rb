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
      get v1_learning_texts_path(params: { page: "one" })

      expected_error = { "errors" => { "page" => ["must be an integer"] } }

      assert_response :bad_request
      assert_equal expected_error, response.parsed_body
    end

    test "#create creates learning texts successfully" do
      mock_author

      post v1_learning_texts_path(params: create_params)

      assert_response :created
    end

    test "#create returns bad_request when params are invalid" do
      action_params = create_params
      action_params[:learning_text][:title] = nil

      post v1_learning_texts_path(params: action_params)

      expected_error = { "errors" => { "learning_text" => { "title" => ["must be filled"] } } }

      assert_response :bad_request
      assert_equal expected_error, response.parsed_body
    end

    test "#create returns unprocessable_entity when action fails" do
      mock_author

      action_params = create_params
      action_params[:learning_text][:base_language] = "ab"

      post v1_learning_texts_path(params: action_params)

      expected_error = { "errors" => { "base" => ["This base language is not supported"] } }

      assert_response :unprocessable_entity
      assert_equal expected_error, response.parsed_body
    end

    private

    # TODO: Remove when authentication in place
    def mock_author
      user = create(:user)
      ApplicationController.any_instance.expects(:current_user).returns(user).at_least_once
    end

    def create_params
      {
        learning_text: {
          title: "title",
          translation_title: "translated title",
          level: "B1",
          visibility: "private",
          base_language: "pl",
          translation_language: "en",
          sentences: [
            { base: "Sentence 1", translation: "Translated sentence 1" },
            { base: "Sentence 2", translation: "Translated sentence 2" }
          ]
        }
      }
    end

    def resources_response_schema
      Dry::Schema.Params do
        required(:learning_texts).array(:hash).schema do
          Schemas::LearningText::SCHEMA
        end
      end
    end
  end
end
