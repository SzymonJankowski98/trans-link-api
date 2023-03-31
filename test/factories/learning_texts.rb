# frozen_string_literal: true

# == Schema Information
#
# Table name: learning_texts
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_learning_texts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :learning_text do
    association :author, factory: :user
    title { "Title" }
  end
end
