source 'https://rubygems.org'

gem 'rails', '3.2.3'

gem 'rake', '12.3.3'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~>3.0.1'

gem 'will_paginate', '3.0.3'

#for google chart
gem "google_visualr", "~> 2.1.0"
#for highchart in rails
gem 'lazy_high_charts'

#to define cron task
#gem 'whenever', :require => false
gem 'rufus-scheduler'

#builder for xml
#gem 'builder update', '~> 2.0'

group :development, :test do
  gem 'sqlite3'
  #gem 'mysql2'
end

#bundle install --without production
group :production do
  gem 'sqlite3'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails'
  #para windows
  #gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git' 
  #tambien correr gem install libv8 -v 3.11.8.0, eventmachine, thin, thin-service, sqlite3
  #antes instalar Active Python
end

gem 'jquery-rails'
gem 'jquery_datepicker'

#gem 'passenger'
gem "thin"
#para windows
#gem "thin_service"


#--gem to schedule task
gem 'clockwork'
gem 'stalker'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
