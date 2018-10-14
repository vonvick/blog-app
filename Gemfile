source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'active_model_serializers', '~> 0.10.7'
gem 'cancancan', '~> 2.3.0'
gem 'cloudinary', '~> 1.9.1'
gem 'devise_token_auth'
gem 'dotenv-rails'
gem 'pg', '~> 1.1.3'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.1.0'
gem 'rack-attack', '~> 5.4.1'
gem 'rack-cors', '~> 1.0.2'
gem 'rubocop-rspec', '~> 1.30.0'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'mailcatcher', '~> 0.2.4'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'database_cleaner', '~> 1.7.0'
  gem 'factory_bot', '~> 4.11.1'
  gem 'faker', '~> 1.9.1'
  gem 'rspec-rails', '~> 3.8'
  gem 'shoulda-matchers', '~> 3.1'
end