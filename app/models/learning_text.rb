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
class LearningText < ApplicationRecord
  belongs_to :author, class_name: "User",
                      foreign_key: :user_id,
                      inverse_of: :learning_texts

  validates :title, presence: true
end
