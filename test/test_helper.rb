# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

require "devise/jwt/test_helpers"
require 'mocha/minitest'

Dir[Rails.root.join("test/support/**/*.rb")].each { require _1 }

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods

    Rails.application.load_seed

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
