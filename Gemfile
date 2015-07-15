source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.1'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer' #, platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# our session data is too much for a mere cookie: https://github.com/rails/activerecord-session_store
gem 'activerecord-session_store', github: 'rails/activerecord-session_store'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
gem 'capistrano', '~> 3.2'
gem 'capistrano-secrets-yml', '~> 1.0.0'
gem 'capistrano-rails'
gem 'capistrano-rbenv'
gem 'capistrano-passenger'
gem 'bootstrap-sass', '~> 3'
gem 'nokogiri'
gem 'mini_portile'
gem 'paperclip'
gem 'rest-client'


group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails', '~> 3'
  gem 'byebug'
  gem 'simplecov', :require => false
  gem 'pry-rails'
  gem 'pry-byebug'
end

group :test do
  gem 'webmock'
  gem 'equivalent-xml', :git => "https://github.com/mbklein/equivalent-xml.git"
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
end

group :staging, :production do
  gem 'pg'
  gem 'rb-readline'
end

