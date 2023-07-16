# frozen_string_literal: true

module LearningTexts
  class Create
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call, :fetch_languages)

    def initialize(action_params, author)
      @action_params = action_params
      @author = author
    end

    def call
      ActiveRecord::Base.transaction do
        yield fetch_languages
        yield create_base_learning_text
        yield create_translation
        yield create_sentences

        Success(base_learning_text)
      end
    end

    private

    attr_reader :action_params,
                :author,
                :base_language,
                :translation_language,
                :base_learning_text,
                :translation_learning_text

    def fetch_languages
      @base_language = yield fetch_base_language
      @translation_language = yield fetch_translation_language

      if base_language == translation_language
        return Failure("Base and translation languages have to be different")
      end

      Success()
    end

    def fetch_base_language
      Language.find_by_with_response(code: action_params[:base_language].downcase)
              .or(Failure("This base language is not supported"))
    end

    def fetch_translation_language
      Language.find_by_with_response(code: action_params[:translation_language].downcase)
              .or(Failure("This translation language is not supported"))
    end

    def create_base_learning_text
      LearningText.create_with_result(**base_learning_text_params)
                  .or { Failure(_1.errors.full_messages.to_sentence) }
                  .fmap { @base_learning_text = _1 }
    end

    def base_learning_text_params
      action_params
        .slice(:title, :level, :visibility)
        .merge(language: base_language, author:)
    end

    def create_translation
      LearningText.create_with_result(**translation_params)
                  .or { Failure(_1.errors.full_messages.to_sentence) }
                  .fmap { @translation_learning_text = _1 }
    end

    def translation_params
      action_params
        .slice(:level, :visibility)
        .merge(title: action_params[:translation_title],
               language: translation_language,
               author:,
               base_learning_text:)
    end

    def create_sentences # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      response = Success()
      action_params[:sentences].each_with_index do |sentence_params, order|
        base_learning_text
          .sentences.create_with_result(text: sentence_params[:base], order:)
          .or do |failure|
            response = Failure(failure.errors.full_messages.to_sentence)
            break
          end

        translation_learning_text
          .sentences.create_with_result(text: sentence_params[:translation], order:)
          .or do |failure|
            response = Failure(failure.errors.full_messages.to_sentence)
            break
          end
      end

      response
    end
  end
end
