# frozen_string_literal: true

# == Schema Information
#
# Table name: learning_texts
#
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
#
# Indexes
#
#  index_learning_texts_on_base_learning_text_id  (base_learning_text_id)
#  index_learning_texts_on_language_id            (language_id)
#  index_learning_texts_on_user_id                (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (base_learning_text_id => learning_texts.id)
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :learning_text do
    association :author, factory: :user
    association :language
    title { "Title" }
    visibility { "public" }
    level { "C1" }
    access_key_enabled { false }

    trait :translation do
      association :base_learning_text, factory: :learning_text
    end
  end
end
