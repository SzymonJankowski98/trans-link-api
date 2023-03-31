# frozen_string_literal: true

module V1
  class LearningTextsController < ApplicationController
    def index
      render json: learning_texts,
             each_serializer: V1::LearningTextSerializer,
             root: "learning_texts",
             status: :ok
    end

    private

    def learning_texts
      LearningText.all
    end
  end
end
