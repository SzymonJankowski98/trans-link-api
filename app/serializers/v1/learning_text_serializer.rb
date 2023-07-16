# frozen_string_literal: true

#  id                    :bigint           not null, primary key
#  access_key            :string
#  access_key_enabled    :boolean          default(FALSE), not null
#  level                 :string           not null
#  title                 :string           not null
#  visibility            :string           default("public"), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  base_learning_text_id :bigint
#  language_id           :bigint           not null
#  user_id               :bigint           not null

module V1
  class LearningTextSerializer < ActiveModel::Serializer
    attribute :id
    attribute :access_key
    attribute :access_key_enabled
    attribute :level
    attribute :title
    attribute :visibility
    attribute :language_id
    attribute :user_id
    attribute :created_at
    attribute :base_learning_text_id

    has_many :translations, serializer: LearningTextSerializer
    has_many :sentences, serializer: SentenceSerializer

    def created_at
      object.created_at.to_datetime
    end
  end
end
