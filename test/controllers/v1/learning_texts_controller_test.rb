# frozen_string_literal: true

require "test_helper"

module V1
  class LearningTextsControllerTest < ActionDispatch::IntegrationTest
    test "#index returns learning texts" do
      learning_texts = create_list(:learning_text, 3, :translation)

      get v1_learning_texts_path(params: { page: 1, extra_param: 1, base_language: ["en"] })

      assert_response :ok
      assert_equal learning_texts.map(&:base_learning_text).pluck(:id),
                   response.parsed_body["learning_texts"].pluck("id")
      assert_predicate index_response_schema.call(response.parsed_body), :success?
    end

    test "#index returns error when params are invalid" do
      get v1_learning_texts_path(params: { page: "one" })

      expected_error = { "errors" => { "page" => ["must be an integer"] } }

      assert_response :bad_request
      assert_equal expected_error, response.parsed_body
    end

    test "#show returns learning text record" do
      base_learning_text = create(:learning_text)
      learning_text = create(:learning_text, :with_access_key, base_learning_text:)
      create(:sentence, learning_text:)
      translation = create(:learning_text, :with_access_key, base_learning_text: learning_text)
      create(:sentence, learning_text: translation)

      get v1_learning_text_path(learning_text.id)

      assert_response :ok
      assert_predicate create_response_schema.call(response.parsed_body), :success?

      body = response.parsed_body["learning_text"]

      assert_predicate body["sentences"], :present?
      assert_predicate body["translations"], :present?
      assert_predicate body["translations"][0]["sentences"], :present?
    end

    test "#show returns not_found when learning text doesn't exist" do
      get v1_learning_text_path(-1)

      expected_error = { "errors" => { "base" => ["Not found"] } }

      assert_response :not_found
      assert_equal expected_error, response.parsed_body
    end

    test "#create creates learning texts successfully" do
      headers = get_auth_token(create(:user))

      assert_difference -> { LearningText.count }, +2 do
        assert_difference -> { Sentence.count }, +4 do
          post v1_learning_texts_path(params: create_params), headers:
        end
      end

      assert_response :created
      assert_predicate create_response_schema.call(response.parsed_body), :success?

      body = response.parsed_body["learning_text"]

      assert_equal 2, body["sentences"].count
      assert_equal 1, body["translations"].count
      assert_equal 2, body["translations"][0]["sentences"].count
    end

    test "#create returns bad_request when params are invalid" do
      headers = get_auth_token(create(:user))

      action_params = create_params
      action_params[:learning_text][:title] = nil

      post(v1_learning_texts_path(params: action_params), headers:)

      expected_error = { "errors" => { "learning_text" => { "title" => ["must be filled"] } } }

      assert_response :bad_request
      assert_equal expected_error, response.parsed_body
    end

    test "#create returns unauthorized when is not authorized" do
      post v1_learning_texts_path(params: {})

      expected_error =  { "error" => "You need to sign in or sign up before continuing." }

      assert_response :unauthorized
      assert_equal expected_error, response.parsed_body
    end

    test "#create returns unprocessable_entity when action fails" do
      headers = get_auth_token(create(:user))

      action_params = create_params
      action_params[:learning_text][:base_language] = "ab"

      post(v1_learning_texts_path(params: action_params), headers:)

      expected_error = { "errors" => { "base" => ["This base language is not supported"] } }

      assert_response :unprocessable_entity
      assert_equal expected_error, response.parsed_body
    end

    test "#destroy deletes learning text with its associations" do
      headers = get_auth_token(create(:user))

      base_learning_text = create(:learning_text)
      learning_text = create(:learning_text, :with_access_key, base_learning_text:)
      create(:sentence, learning_text:)
      translation = create(:learning_text, :with_access_key, base_learning_text: learning_text)
      create(:sentence, learning_text: translation)

      assert_difference -> { LearningText.count }, -2 do
        assert_difference -> { Sentence.count }, -2 do
          delete v1_learning_text_path(learning_text.id), headers:
        end
      end

      assert_response :no_content
    end

    test "#destroy returns not_found when learning text doesn't exist" do
      headers = get_auth_token(create(:user))

      delete(v1_learning_text_path(-1), headers:)

      expected_error = { "errors" => { "base" => ["Not found"] } }

      assert_response :not_found
      assert_equal expected_error, response.parsed_body
    end

    test "#destroy returns unauthorized when is not authorized" do
      delete v1_learning_text_path(-1)

      expected_error =  { "error" => "You need to sign in or sign up before continuing." }

      assert_response :unauthorized
      assert_equal expected_error, response.parsed_body
    end

    private

    def get_auth_token(user)
      Devise::JWT::TestHelpers.auth_headers({}, user)
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

    def index_response_schema
      Dry::Schema.Params do
        required(:learning_texts).array(:hash).schema do
          ResponseSchemas::LearningText
        end
      end
    end

    def create_response_schema
      Dry::Schema.Params do
        required(:learning_text).schema do
          ResponseSchemas::LearningText
        end
      end
    end
  end
end
