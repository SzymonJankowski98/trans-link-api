# frozen_string_literal: true

module LearningTexts
  class Finder
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :sort_column, :string
    attribute :sort_direction, :string
    attribute :search, :string
    attribute :id, array: true
    attribute :base_language, array: true
    attribute :translation_language, array: true

    def call
      scope

      apply_search
      apply_base_language_filter
      apply_translation_language_filter
      apply_filters
      apply_order
    end

    private

    SORT_DIRECTIONS = %w[desc asc].freeze
    DEFAULT_SORT_DIRECTION = "desc"

    SORT_COLUMNS = %w[title created_at].freeze
    DEFAULT_SORT_COLUMN = "created_at"

    FILTER_COLUMNS = %w[id].freeze

    private_constant :SORT_DIRECTIONS, :DEFAULT_SORT_DIRECTION, :SORT_COLUMNS,
                     :DEFAULT_SORT_COLUMN, :FILTER_COLUMNS

    def apply_filters
      FILTER_COLUMNS.each do |attr|
        next unless send(attr)

        @scope = scope.where(attr => send(attr))
      end
    end

    def apply_search
      return unless search

      @scope = scope.where("learning_texts.title ILIKE ?", "%#{search}%")
    end

    def apply_base_language_filter
      return unless base_language

      base_learning_text_ids =
        LearningText
        .base_texts
        .joins(:language)
        .where(languages: { code: base_language })
        .ids

      @scope = scope.where(base_learning_text_id: base_learning_text_ids)
    end

    def apply_translation_language_filter
      return unless translation_language

      @scope = scope.joins(:language).where(languages: { code: translation_language })
    end

    def apply_order
      @scope = scope.order(final_sort_column => final_sort_direction)
    end

    def final_sort_column
      sort_column.presence_in(SORT_COLUMNS) || DEFAULT_SORT_COLUMN
    end

    def final_sort_direction
      sort_direction.presence_in(SORT_DIRECTIONS) || DEFAULT_SORT_DIRECTION
    end

    def scope
      @scope ||= LearningText.translations
    end
  end
end
