Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDISTOGO_URL"] }
end unless ENV["REDISTOGO_URL"].blank?


Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDISTOGO_URL"] }
end unless ENV["REDISTOGO_URL"].blank?