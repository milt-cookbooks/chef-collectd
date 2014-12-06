source 'https://rubygems.org'

group :lint do
  gem 'foodcritic', '~> 3.0'
  gem 'rubocop', '= 0.23'
  gem 'rainbow', '< 2.0'
end

group :unit do
  gem 'berkshelf', '~> 3.1'
  gem 'chefspec', '~> 4.0'
end

group :kitchen_common do
  gem 'test-kitchen', '~> 1.2'
end

group :kitchen_cloud do
  gem 'droplet_kit', '< 1.1.0' if RUBY_VERSION < '2'
  gem 'kitchen-digitalocean', :require => false
end

group :development do
  gem 'libnotify'
  gem 'guard', '~> 2.6'
  gem 'guard-kitchen'
  gem 'guard-foodcritic'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rake'
  gem 'emeril'
end
