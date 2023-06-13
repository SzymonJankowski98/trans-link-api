# frozen_string_literal: true

require "test_helper"

module LearningTexts
  class IndexSchemaTest < ActiveSupport::TestCase
    test "returns success when params are valid" do
      result = IndexSchema.new.call(valid_params)

      assert_predicate result, :success?
    end

    test "returns failure when params are invalid" do
      result = IndexSchema.new.call(invalid_params)

      assert_predicate result, :failure?
      assert_equal expected_error, result.errors.to_h # rubocop:disable Rails/DeprecatedActiveModelErrorsMethods
    end

    private

    def valid_params
      {
        id: [1],
        title: "title",
        page: 1,
        per_page: 25,
        sort_column: "column",
        sort_direction: "desc",
        extra_param: 1
      }
    end

    def invalid_params
      {
        id: "id",
        title: [1],
        page: "1",
        per_page: "25",
        sort_column: 1,
        sort_direction: 1
      }
    end

    def expected_error
      {
        id: ["must be an array"],
        title: ["must be a string"],
        sort_column: ["must be a string"],
        sort_direction: ["must be a string"]
      }
    end
  end
end
