# frozen_string_literal: true

# == Schema Information
#
# Table name: languages
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Language < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true

  has_many :learning_texts,
           class_name: "LearningText",
           dependent: :destroy
end
