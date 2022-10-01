ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require_relative './helpers/indirizzo'
require 'rails/test_help'
require "minitest/rails"
require "minitest/pride"
require "minitest/reporters"
require 'minitest/spec'
require 'minitest/autorun'
require 'mocha/minitest'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
