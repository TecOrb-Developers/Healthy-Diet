web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: bundle exec sidekiq -e production
clock: bundle exec clockwork lib/clock.rb