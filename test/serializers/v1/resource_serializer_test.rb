# frozen_string_literal: true

require "test_helper"

module V1
  class ResourceSerializerTest < ActiveSupport::TestCase
    test "serializes attributes" do
      resource = create(:resource)
      serialization = ResourceSerializer.new(resource).as_json

      assert_predicate Schemas::Resource::SCHEMA.call(serialization), :success?
    end
  end
end
