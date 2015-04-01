if Rails.env.development?
REDIS = Redis.new
elsif Rails.env.test?
REDIS = Redis.new
elsif Rails.env.production?
uri = URI.parse(ENV["REDISTOGO_URL"])
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end