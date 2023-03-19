# frozen_string_literal: true

module V1
  class ResourceSerializer < ActiveModel::Serializer
    attribute :id
    attribute :user_id
    attribute :type
    attribute :visibility
  end
end
