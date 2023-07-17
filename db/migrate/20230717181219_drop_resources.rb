# frozen_string_literal: true

class DropResources < ActiveRecord::Migration[7.0]
  def change
    drop_table :resources # rubocop:disable Rails/ReversibleMigration
  end
end
