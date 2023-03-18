# frozen_string_literal: true

module V1
  class UserSerializer < BaseSerializer
    attribute :id
    attribute :email
  end
end
