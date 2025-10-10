# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?

# CRITICAL: Load all Rails components early to initialize ActionView/ERB handlers
require 'rails/all'

# Load Devise for auth helpers
require 'devise'

# Now load RSpec and helpers
require 'spec_helper'
require 'rspec/rails'

# Requires support files (e.g., for Devise, FactoryBot)
Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

# Maintains test schema
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Use transactional fixtures for speed/isolation
  config.use_transactional_fixtures = true

  # Infer spec type from file location (e.g., *_spec.rb -> request/model)
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces
  config.filter_rails_from_backtrace!

  # FactoryBot syntax methods (e.g., create(:user))
  config.include FactoryBot::Syntax::Methods

  # Set host for request specs
  config.before(:each, type: :request) do
    host! "www.example.com"
  end

  # Devise test setup (cleans up sessions)
  config.before(:suite) do
    Warden.test_mode!
  end

  config.after(:each) do
    Warden.test_reset!
  end
end

# Global route defaults for mailers/tests
Rails.application.routes.default_url_options[:host] = "www.example.com"