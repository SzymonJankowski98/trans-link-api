# frozen_string_literal: true

module LearningTexts
  class Create
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)

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
      @base_language = Language.find_by(code: action_params[:base_language].downcase)
      return Failure("This base language is not supported") if base_language.blank?

      @translation_language = Language.find_by(code: action_params[:translation_language].downcase)
      return Failure("This translation language is not supported") if translation_language.blank?

      if base_language == translation_language
        return Failure("Base and translation languages have to be different")
      end

      Success()
    end

    def create_base_learning_text
      @base_learning_text = LearningText.create(**base_learning_text_params)
      unless base_learning_text.persisted?
        return Failure(base_learning_text.errors.full_messages.to_sentence)
      end

      Success()
    end

    def base_learning_text_params
      action_params
        .slice(:title, :level, :visibility)
        .merge(language: base_language, author:)
    end

    def create_translation
      @translation_learning_text = LearningText.create(**translation_params)
      unless translation_learning_text.persisted?
        return Failure(translation_learning_text.errors.full_messages.to_sentence)
      end

      Success()
    end

    def translation_params
      action_params
        .slice(:level, :visibility)
        .merge(title: action_params[:translation_title],
               language: translation_language,
               author:,
               base_learning_text:)
    end

    def create_sentences
      response = Success()
      action_params[:sentences].each_with_index do |sentence_params, order|
        sentence = base_learning_text.sentences.create(text: sentence_params[:base], order:)
        unless sentence.persisted?
          response = Failure(sentence.errors.full_messages.to_sentence)
          break
        end

        translated_sentence =
          translation_learning_text.sentences.create(text: sentence_params[:translation], order:)
        unless translated_sentence.persisted?
          response = Failure(translated_sentence.errors.full_messages.to_sentence)
          break
        end
      end

      response
    end
  end
end
