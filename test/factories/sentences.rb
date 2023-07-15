# == Schema Information
#
# Table name: sentences
#
#  id               :bigint           not null, primary key
#  order            :integer          not null
#  text             :text             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  learning_text_id :bigint           not null
#
# Indexes
#
#  index_sentences_on_learning_text_id  (learning_text_id)
#
# Foreign Keys
#
#  fk_rails_...  (learning_text_id => learning_texts.id)
#
FactoryBot.define do
  factory :sentence do
    order { 1 }
    learning_text
    text { "Example sentence." }
  end
end
