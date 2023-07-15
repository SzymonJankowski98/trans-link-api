# frozen_string_literal: true

class UpdateLearningTextsAssociations < ActiveRecord::Migration[7.0]
  def change
    rename_column :learning_texts, :base_language_id, :language_id
    remove_column :learning_texts, :translation_language_id, :bigint
    add_reference :learning_texts, :base_learning_text, foreign_key: { to_table: :learning_texts }
  end
end
