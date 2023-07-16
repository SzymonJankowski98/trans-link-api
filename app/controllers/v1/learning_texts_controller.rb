# frozen_string_literal: true

module V1
  class LearningTextsController < ApplicationController
    before_action :authenticate_user!, except: %i[show index]
    before_action :validate_params!, only: %i[index create]

    def index
      render json: learning_texts.records,
             each_serializer: V1::LearningTextSerializer,
             root: "learning_texts",
             meta: learning_texts.metadata
    end

    def show
      render json: learning_text,
             serializer: V1::LearningTextSerializer,
             status: :ok,
             include: ["sentences", "translations.sentences"],
             root: "learning_text"
    end

    def create
      response = create_action

      if response.success?
        render json: response.value!,
               serializer: V1::LearningTextSerializer,
               status: :created,
               include: ["sentences", "translations.sentences"],
               root: "learning_text"
      else
        render_errors response.failure, status: :unprocessable_entity
      end
    end

    def destroy
      if learning_text.destroy
        render status: :no_content
      else
        render_errors learning_text.errors.details, status: :unprocessable_entity
      end
    end

    private

    def learning_text
      @learning_text ||= rescuable_find(LearningText, params[:id])
    end

    def create_action
      LearningTexts::Create.new(safe_params[:learning_text], current_user).call
    end

    def pagination_params
      safe_params.slice(:page, :per_page).to_h.symbolize_keys
    end

    def finder_params
      safe_params.slice(:sort_column, :sort_direction, :id)
    end

    def learning_texts
      @learning_texts ||= begin
        base_learning_text_ids =
          LearningTexts::Finder.new(**finder_params).call.pluck(:base_learning_text_id)
        learning_texts = LearningText.where(id: base_learning_text_ids)
        Pagination.new(learning_texts, **pagination_params).call
      end
    end
  end
end
