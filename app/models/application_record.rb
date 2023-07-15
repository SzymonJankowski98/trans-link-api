# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  extend Dry::Monads[:result]

  primary_abstract_class

  def self.create_with_result(...)
    record = create(...)
    return Success(record) if record.persisted?

    Failure(record)
  end
end
