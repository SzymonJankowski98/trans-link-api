# frozen_string_literal: true

# == Schema Information
#
# Table name: learning_texts
#
#  id                      :bigint           not null, primary key
#  access_key              :string
#  access_key_enabled      :boolean          default(FALSE), not null
#  level                   :string           not null
#  title                   :string           not null
#  visibility              :string           default("public"), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  base_language_id        :bigint           not null
#  translation_language_id :bigint           not null
#  user_id                 :bigint           not null
#
# Indexes
#
#  index_learning_texts_on_base_language_id         (base_language_id)
#  index_learning_texts_on_translation_language_id  (translation_language_id)
#  index_learning_texts_on_user_id                  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (base_language_id => languages.id)
#  fk_rails_...  (translation_language_id => languages.id)
#  fk_rails_...  (user_id => users.id)
#
class LearningText < ApplicationRecord
  VISIBILITIES = [
    PUBLIC = "public",
    PRIVATE = "private"
  ].freeze

  LEVELS = [
    C2 = "C2",
    C1 = "C1",
    B2 = "B2",
    B1 = "B1",
    A2 = "A2",
    A1 = "A1"
  ].freeze

  belongs_to :author, class_name: "User",
                      foreign_key: :user_id,
                      inverse_of: :learning_texts
  belongs_to :base_language, class_name: "Language"
  belongs_to :translation_language, class_name: "Language"

  validates :title, presence: true
  validates :access_key_enabled, inclusion: [true, false]
  validates :visibility, inclusion: { in: VISIBILITIES }
  validates :level, inclusion: { in: LEVELS }
end
