source 'https://rubygems.org'

gem 'rails', '3.2.5'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

# Add haml gem to rails
gem 'haml-rails'

# fancy theme!
gem 'web-app-theme', :git =>'git://github.com/pilu/web-app-theme.git'

# autocomplete for rails
gem 'rails3-jquery-autocomplete'

gem 'execjs'
gem 'therubyracer'

# mysql gem for production db
gem 'mysql'
gem 'mysql2'

group :development do
  gem 'hpricot'
  gem 'ruby_parser'
end

gem 'rspec-rails', group: [:development, :test]
group :test do
  gem 'database_cleaner'
  gem 'nyan-cat-formatter', '~> 0.0.7'
  gem 'factory_girl_rails'
end
# Get some nifty generaters up in here
gem "nifty-generators", :group => :development

# Nested form gem for simple... well, nested forms
gem "nested_form"

# Add sidekiq gem for background processing
gem 'sidekiq'

# Add Sinatra and Slim for sidekiq's web interface
gem 'sinatra', require: false
gem 'slim'

# Add net-ldap Krogebry's repo to fix dumb M$ utf8 garbage bug
gem 'net-ldap', git: 'git://github.com/krogebry/ruby-net-ldap-1.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

#gem "mocha", :group => :test
