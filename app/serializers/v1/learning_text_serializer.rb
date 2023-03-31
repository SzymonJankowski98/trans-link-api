# frozen_string_literal: true

module V1
  class LearningTextSerializer < ActiveModel::Serializer
    attribute :id
    attribute :user_id
    attribute :title
    attribute :created_at

    def created_at
      object.created_at.to_datetime
    end
  end
end
