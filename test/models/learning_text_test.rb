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
require "test_helper"

class LearningTextTest < ActiveSupport::TestCase
  test "#belongs_to user as author returns associated record" do
    author = create(:user)
    learning_text = create(:learning_text, author:)

    assert_equal author, learning_text.author
  end

  test "#belongs_to language returns associated record" do
    language = create(:language)
    learning_text = create(:learning_text, language:)

    assert_equal language, learning_text.language
  end

  test "#belongs_to base_learning_text returns associated record" do
    base_learning_text = create(:learning_text)
    translation_learning_text = create(:learning_text, base_learning_text: base_learning_text)

    assert_equal base_learning_text, translation_learning_text.base_learning_text
  end

  test "#has_many sentences returns accociated records" do
    learning_text = create(:learning_text)
    sentences = create_list(:sentence, 2, learning_text:)

    assert_equal sentences, learning_text.sentences
  end

  test "#has_many translations returns accociated records" do
    base_learning_text = create(:learning_text)
    translation_learning_texts = create_list(:learning_text, 2, base_learning_text:)

    assert_equal translation_learning_texts, base_learning_text.translations
  end

  test "validates presence of attributes" do
    %i[title].each do |attribute|
      learning_text = build(:learning_text, attribute => nil)
      blank_error = { error: :blank }

      assert_not learning_text.valid?
      assert_equal blank_error, learning_text.errors.details[attribute]&.first
    end
  end

  test "validates inclusion of level" do
    learning_text = build(:learning_text, level: "Master")
    blank_error = { error: :inclusion, value: "Master" }

    assert_not learning_text.valid?
    assert_equal blank_error, learning_text.errors.details[:level]&.first
  end

  test "validates inclusion of visibility" do
    learning_text = build(:learning_text, visibility: "None")
    blank_error = { error: :inclusion, value: "None" }

    assert_not learning_text.valid?
    assert_equal blank_error, learning_text.errors.details[:visibility]&.first
  end

  test "validates inclusion of access_key_enabled" do
    learning_text = build(:learning_text, access_key_enabled: nil)
    blank_error = { error: :inclusion, value: nil }

    assert_not learning_text.valid?
    assert_equal blank_error, learning_text.errors.details[:access_key_enabled]&.first
  end
end
