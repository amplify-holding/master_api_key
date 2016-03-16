# Setup

First, build and install the gem locally.

    $ gem build master_api_key.gemspec
    $ gem install ./master_api_key-0.0.0.gem

Then, include the gem into your project's GemFile

    $ gem 'master_api_key', ~> 0.0.0


Finally, generate the record, controller, and migrate the table

    $ rails generate master_api_key:active_record
    $ rake db:migrate
    
# Usage 

## Its components ##

The core module of this project is "Security::ApiGatekeeper", which has the logic to validate the Api Tokens used to call the APIs.

## Controllers ##

1) ApiKeyController - actions
   * create - Make a POST request with the param "scope_id" to generate a new API Token associated with it.
   * "destroy" and "destroy_by_api_token" are for deleting the existing tokens
 
# Testing

To test this gem, you'll need to run the following command:

    $ rake test
     