
  require 'sidekiq/web'
  mount Sidekiq::Web, at: "/sidekiq"
