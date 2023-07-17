# frozen_string_literal: true

require "test_helper"

class PaginationTest < ActiveSupport::TestCase
  test "returns results with default amount of records" do
    users = create_list(:user, 26)

    result = Pagination.new(User.all).call

    expected_users = users.first(25)
    expected_metadata = {
      previous_page: nil,
      current_page: 1,
      next_page: 2,
      total_pages: 2,
      total_count: 26
    }

    assert_equal expected_users, result.records
    assert_equal expected_metadata, result.metadata
  end

  test "returns results acording to maximum amount of records" do
    users = create_list(:user, 101)

    result = Pagination.new(User.all, per_page: 101).call

    expected_users = users.first(100)
    expected_metadata = {
      previous_page: nil,
      current_page: 1,
      next_page: 2,
      total_pages: 2,
      total_count: 101
    }

    assert_equal expected_users, result.records
    assert_equal expected_metadata, result.metadata
  end

  test "returns results from the second page" do
    users = create_list(:user, 15)

    result = Pagination.new(User.all, page: 2, per_page: 5).call

    expected_users = users.first(10).last(5)
    expected_metadata = {
      previous_page: 1,
      current_page: 2,
      next_page: 3,
      total_pages: 3,
      total_count: 15
    }

    assert_equal expected_users, result.records
    assert_equal expected_metadata, result.metadata
  end

  test "returns empty page on overflow" do
    create(:user)

    result = Pagination.new(User.all, page: 2).call

    expected_metadata = {
      previous_page: 1,
      current_page: 2,
      next_page: nil,
      total_pages: 1,
      total_count: 1
    }

    assert_empty result.records
    assert_equal expected_metadata, result.metadata
  end
end
