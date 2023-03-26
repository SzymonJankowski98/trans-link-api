# frozen_string_literal: true

class Pagination
  include Pagy::Backend

  def initialize(scope, page: DEFAULT_PAGE, per_page: DEFAULT_PER_PAGE)
    @scope = scope
    @page = page
    @per_page = per_page
  end

  def call
    apply_paginantion
    result
  end

  private

  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 25
  MAX_PER_PAGE = 100
  RESULT_STRUCT = Struct.new(:records, :metadata)
  private_constant :DEFAULT_PAGE, :DEFAULT_PER_PAGE, :MAX_PER_PAGE, :RESULT_STRUCT

  attr_reader :scope, :pagy_data, :page

  def apply_paginantion
    @pagy_data, @scope = pagy(scope, page:, items: per_page)
  end

  def result
    RESULT_STRUCT.new(records: scope, metadata:)
  end

  def metadata
    {
      previous_page: pagy_pagination[:prev],
      current_page: pagy_pagination[:page],
      next_page: pagy_pagination[:next],
      total_pages: pagy_pagination[:pages],
      total_count: pagy_pagination[:count]
    }
  end

  def pagy_pagination
    @pagy_pagination ||= pagy_metadata(pagy_data)
  end

  def per_page
    [@per_page, MAX_PER_PAGE].min
  end

  def pagy_url_for(*)
    nil
  end
end
