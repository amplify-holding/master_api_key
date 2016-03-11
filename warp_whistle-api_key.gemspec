Gem::Specification.new do |s|
  s.name        = 'warp_whistle-api_key'
  s.version     = '0.0.0'
  s.date        = '2016-03-09'
  s.summary     = 'Secure Access of API with API Keys.'
  s.description = 'This gem gives a developer a set of tools to provide authorized access their endpoints.'
  s.authors     = ['Flynn Jones', 'Prakash Vadrevu', 'Srikanth Gurram']
  s.email       = ['fjones@amplify.com', 'pvadrevu@amplify.com', 'sgurram@amplify.com ']
  s.files       = Dir['{lib}/**/*.rb', 'README.md']
  s.homepage    =
      'http://rubygems.org/gems/warp_whistle-api_key'
  s.license       = 'MIT'
  s.add_dependency('rails', '>= 3.0.0')
end