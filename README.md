# Description #

The Master Api Key gem allows you to easily integrate API access restrictions into your services.
This gem will provide an API to create API Keys and revoke API access. 

In addition, it provides basic authorization with controller groups. With controller groups,
you can separate your APIs into logical packages or products. 

For example, you can have an AdminController and UserController under the "Users" group or
a MapsControllers, LocationsController, TrafficController under the "Maps" group. 
This allows you to only give access to related controllers to a client easily.

# Using Master Api Key #
## Setup ##

First, include the gem into your project's GemFile

    $ gem 'master_api_key', ~> 0.0.3

Then, generate the record, controller, and migrate the table

    $ rails generate master_api_key:active_record
    $ rake db:migrate

## Using the API ##
 
###Generating an API key to Grant Access###
---
####Description####
This endpoint is for generating new API keys. Ensure that you keep track of who 
you've given access to the key. That way if you ever need to revoke the key, you'll
know who to contact to prevent outages for your clients.

####Endpoint####

    POST /api_key
    
####Parameters####

| Param Name    | Type        | Required  | Description  |
| ------------- |------------- | --------- | --------- |
| group      | string | no | the name of a collection of controllers to grand access. Not providing a group will grant access to all public APIs |

####Responses####

| Response Code | Description |
| ------------- |------------ |
| 201           | Created     |
 
 _Example_     
```json
    {
        "apiKey":{
                    "id":1,
                    "access_token":"h7Uty6gPo5eYyA3VQPd-4w",
                    "group":"hello"
                 },
        "status":"created"
    }
```
###Deleting an API Key by Record Id###
---
####Description####

    Revokes access for anyone using the associated api key
    
####Endpoint####

    DELETE /api_key/:id
    
####Parameters####

| Param Name    | Type        | Required  | Description  |
| ------------- |------------- | --------- | --------- |
| id      | int | yes | An integer representing the record id within the database |

####Responses####

| Response Code | Description  |
| ------------- |------------- |
| 200 | Success |
| 400 | A required parameter is missing |
 
 _Example_     
```json
    {
        "status":"ok"
    }
```
###Deleting an API Key by Access Token###
---
####Description####

    Revokes access for anyone using the associated api key
    
####Endpoint####

    DELETE /api_key
    
####Parameters####

| Param Name    | Type        | Required  | Description  |
| ------------- |------------- | --------- | --------- |
| access_token      | string | yes | A string associated with the access token of an API Key |

####Responses####

| Response Code | Description  |
| ------------- |------------- |
| 200 | Success |
| 400 | A required parameter is missing |
 
 _Example_     
```json
    {
        "status":"ok"
    }
```
## Restricting Access to your APIs ##
### Clients using your APIs ###
When retricting access to your APIs, a new header field in your http request will be required.
The header key/value is:

    X-API-TOKEN: <access_token>

If the access token is within the api_keys table and has been authorized to access the controller,
then the user will be allowed to access you endpoint.

However, if the access token is not within the api_keys table then the user is considered not authenticated.

| Error Code | Http Code Name |
| ------------- |------------ |
| 401 | Unauthorized |

If the access token was authenticated but was not authorized to use the endpoint, then the following error code will be returned:

| Error Code | Http Code Name |
| ------------- |------------ |
| 403 | Forbidden |

### Integrating Master Api Key into your Controllers ###

The core module of this project is "Security::ApiGatekeeper", which has the logic to validate the Api Tokens used to call the APIs.
The method to restrict access is by either adding a filter to the top of the controller or explicitly
calling the method to restrict access.

```ruby
#Restricting access by filters
before_action :authorize_action, only: [:create]

#Restricting access by explicitly calling method.
#If the call is authorized then the code block passed in will be executed.
def index
    authorize_action do
        head :ok
    end
end
```
If you want to override the default behavior when a request is considered 
not authenticated or unauthorized, you can override the following methods from ApiGateKeeper 
in your calling controller.

```ruby
    #Called when a request was not authenticated.
    def on_authentication_failure
      head(:unauthorized)
    end

    #Called when a request is not authorized
    def on_forbidden_request
      head(:forbidden)
    end
```

# Developing For the Gem #

## Workstation Setup ##

### Database Setup ###
To create the necessary databases, do the following:

    $ mysql -u root   
```sql
CREATE DATABASE api_authenticator;
CREATE DATABASE api_authenticator_test;
```
If you are making record changes and need to reset the database. 
Just delete the databases and recreate them.

### Building the Gem ###
Use the build gem script if you want a simple way to setup your workstation for development.
The script goes through several steps before verifting the build.
1. The RSpec unit tests are run against master_api_key
2. The gem is built and installed in the current ruby environment
3. Scaffolding for the rails-api-authenticator example app are generated
...(Please Note) If the scaffolding already exists, it will not override them.
...This is default rails behavior.
4. The Rspec integration tests are run within the example app.

Once all tests are green, then it should be safe to push the gem to the repository. 

The basic usage for the build script is the following:

    $ ./build_gem.sh

During development you will need to update the gems, especially when you update the version file.
The option -u will update all gems including master_api_key

    $ ./build_gem.sh -u
    
For additional help use the -h option
 
### Testing ###

To explicitly test this gem, you'll need to run the following command:

    $ rake test
     