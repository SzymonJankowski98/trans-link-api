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
require "test_helper"

class LanguageTest < ActiveSupport::TestCase
  test "validates presence of attributes" do
    %i[name code].each do |attribute|
      learning_text = build(:language, attribute => nil)
      blank_error = { error: :blank }

      assert_not learning_text.valid?
      assert_equal blank_error, learning_text.errors.details[attribute]&.first
    end
  end

  test "#has_many learning_texts returns accociated records" do
    language = create(:language)
    learning_texts = create_list(:learning_text, 2, language: language)

    assert_equal learning_texts, language.learning_texts
  end

  test "database containes default languages" do
    assert Language.find_by(code: "en")
    assert Language.find_by(code: "pl")
    assert Language.find_by(code: "de")
  end
end
