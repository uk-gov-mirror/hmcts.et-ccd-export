# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Sidekiq - Used to receive the jobs from the API service
gem 'sidekiq', '~> 5.2', '>= 5.2.7'
gem 'sidekiq_alive', '~> 1.1'
gem 'sidekiq-failures', '~> 1.0'

gem 'activesupport', '~> 5.2', '>= 5.2.3'

# Azure deployment so we need this
gem 'azure_env_secrets', git: 'https://github.com/ministryofjustice/azure_env_secrets.git', tag: 'v0.1.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'

group :test do
  gem 'rspec', '~> 3.8'
end
