# frozen_string_literal: true

class CreateLearningTexts < ActiveRecord::Migration[7.0]
  def change
    create_table :learning_texts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false

      t.timestamps
    end
  end
end
