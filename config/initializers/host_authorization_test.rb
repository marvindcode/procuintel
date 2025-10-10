if Rails.env.test?
  Rails.application.config.hosts.clear
  Rails.application.config.middleware.delete ActionDispatch::HostAuthorization
end
