source "https://rubygems.org"

gem "jets", "~> 3.1.0"


# Include mysql2 gem if you are using ActiveRecord, remove next line
# and config/database.yml file if you are not
gem "mysql2", "~> 0.5.3"

gem "dynomite"
gem "zeitwerk", "~> 2.5.0"

gem 'uuid', '~> 2.3', '>= 2.3.8'
gem 'state_machines-activerecord'

# development and test groups are not bundled as part of the deployment
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'shotgun'
  gem 'rack'
  gem 'puma'
end

group :test do
  gem 'rspec' # rspec test group only or we get the "irb: warn: can't alias context from irb_context warning" when starting jets console
  gem 'launchy'
  gem 'capybara'
end
