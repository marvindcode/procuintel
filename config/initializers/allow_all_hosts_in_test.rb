Rails.application.configure do
  config.hosts.clear if Rails.env.test?
end
