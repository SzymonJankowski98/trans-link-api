# frozen_string_literal: true

class AddColumnsToLearningTexts < ActiveRecord::Migration[7.0]
  def change
    change_table :learning_texts, bulk: true do |t|
      t.references :base_language, null: false, foreign_key: { to_table: :languages }
      t.references :translation_language, null: false, foreign_key: { to_table: :languages }
      t.string :visibility, null: false, default: "public"
      t.string :level, null: false
      t.string :access_key
      t.boolean :access_key_enabled, null: false, default: false
    end
  end
end
