require File.expand_path('../lib/master_api_key/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'master_api_key'
  s.version     = MasterApiKey::VERSION
  s.date        = '2016-04-14'
  s.summary     = 'Secure Access of API with API Keys.'
  s.description = 'This gem gives a developer a set of tools to provide authorized access their endpoints.'
  s.authors     = ['Flynn Jones', 'Prakash Vadrevu', 'Srikanth Gurram']
  s.email       = ['flynn.jones@outlook.com', 'pvadrevu@amplify.com', 'sgurram@amplify.com ']
  s.files       = Dir['{lib,app,db,config}/**/*.{rb,gemversion}']
  s.test_files  = Dir['{spec}/**/*']
  s.homepage    = 'https://github.com/amplify-holding/master_api_key'
  s.license     = 'MIT'
  s.cert_chain  = ['certs/master_api_key-public_cert.crt']
  s.signing_key = File.expand_path('~/.gem/master_api_key-private_key.pem')
  s.add_dependency('rails', ['>= 4.0', '< 5.0'])
  s.add_development_dependency('rspec', '~> 3.4')
  s.add_development_dependency('rspec-rails', '~> 3.4')
  s.add_development_dependency('activerecord-jdbcmysql-adapter', '~> 1.3')
end