#$:.push File.expand_path('../lib', __FILE__)
# Maintain your gem's version:
#require "lib/security/version"


require File.expand_path('../lib/security/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'master_api_key'
  s.version     = Security::MASTER_API_KEY_VERSION
  s.date        = '2016-03-09'
  s.summary     = 'Secure Access of API with API Keys.'
  s.description = 'This gem gives a developer a set of tools to provide authorized access their endpoints.'
  s.authors     = ['Flynn Jones', 'Prakash Vadrevu', 'Srikanth Gurram']
  s.email       = ['fjones@amplify.com', 'pvadrevu@amplify.com', 'sgurram@amplify.com ']
  s.files       = Dir['{lib}/**/*.rb', '{app}/**/*.rb', 'README.md']
  s.test_files  = Dir['{spec}/**/*']
  s.homepage    =
      'http://rubygems.org/gems/master_api_key'
  s.license       = 'MIT'
  s.add_dependency('rails', '>= 3.0.0')
  s.add_development_dependency('rspec', '~> 3.4')
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'activerecord-jdbcmysql-adapter'

  #s.add_development_dependency 'capybara'
  #s.add_development_dependency 'factory_girl_rails'
end