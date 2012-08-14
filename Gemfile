source 'https://rubygems.org'

gem 'rails', '3.2.3'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~>3.0.1'

gem 'will_paginate', '3.0.3'

#for google chart
gem "google_visualr", "~> 2.1.0"

#to define cron task
#gem 'whenever', :require => false

#builder for xml
#gem 'builder update', '~> 2.0'

group :development, :test do
  gem 'sqlite3'
  #gem 'mysql2'
end

#bundle install --without production
group :production, :test do
  #gem 'sqlite3'
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails'
end

gem 'jquery-rails'

gem 'jquery_datepicker'

#gem 'passenger'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
