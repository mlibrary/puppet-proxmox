source ENV['GEM_SOURCE'] || 'https://rubygems.org'

# group :test do
  gem 'voxpupuli-test', '~> 14.0',  :require => false
#   gem 'puppet_metadata', '~> 6.1',  :require => false
# end
#
# group :system_tests do
#   gem 'voxpupuli-acceptance', '~> 4.4',  :require => false
# end

gem 'rake', :require => false

gem 'openvox', ENV.fetch('OPENVOX_GEM_VERSION', [">= 8", "< 9"]), :require => false, :groups => [:test]
