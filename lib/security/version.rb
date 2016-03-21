module Security
  MASTER_API_KEY_VERSION = lambda {
    version = '0.0.0'
    File.open('master_api_key.gemversion', 'r') do |f|
      version = f.readline
    end
    version
  }.call
end