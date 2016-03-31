module MasterApiKey
  class Engine < ::Rails::Engine
    isolate_namespace MasterApiKey

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.integration_tool :rspec, :fixture => false, :views => false
      #g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

  end
end