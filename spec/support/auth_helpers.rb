require 'rails_helper'

RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :request
end

def sign_in_as(user)
  sign_in(user, scope: :user)
end