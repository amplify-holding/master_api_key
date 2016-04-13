module MasterApiKey
  VERSION = lambda {
    version = '0.0.0'
    File.open(File.join(File.dirname(__FILE__), '../../config/master_api_key.gemversion'), 'r') do |f|
      version = f.readline
    end
    version
  }.call
end