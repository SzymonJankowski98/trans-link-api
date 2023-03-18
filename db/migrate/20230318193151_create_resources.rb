# frozen_string_literal: true

class CreateResources < ActiveRecord::Migration[7.0]
  def change
    create_table :resources do |t|
      t.references :user, null: false, foreign_key: true
      t.string :type
      t.string :visibility

      t.timestamps
    end
  end
end
