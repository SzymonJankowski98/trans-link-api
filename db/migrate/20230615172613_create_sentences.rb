class CreateSentences < ActiveRecord::Migration[7.0]
  def change
    create_table :sentences do |t|
      t.integer :order, null: false
      t.references :learning_text, null: false, foreign_key: true
      t.text :text, null: false

      t.timestamps
    end
  end
end
