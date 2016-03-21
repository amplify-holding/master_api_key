# README #

This is an example ruby application under development, which aims at securing Rails' web app's APIs using API Tokens. 

Currently, this is a bare minimal web app housing the logic for Api Token generation and validation.


## Controllers ##

1) ApiKeyController - actions
   * create - Make a POST request with the param "scope_id" to generate a new API Token associated with it.
   * "destroy" and "destroy_by_access_token" are for deleting the existing tokens

1) AdminController - actions
   * "index" and "create" - return a success message when called.

## Setup ##
### Create Database ###
    mysql -u root
    CREATE DATABASE api_authenticator;
    CREATE DATABASE api_authenticator_test;

### Generate required classes and migrate the database ###

    rails g master_api_key:active_record

    rake db:migrate
### Run the Rails app ###
    bundle exec rails s


## Using the Example API ##
* Generate an API Token with some dummy scope_id using the curl command
     

```
#!

curl -X POST http://localhost:3000/api_key -d 'group=hello'
```

* The new token created is returned to the caller and hence is printed on the console
  Expected response:

```
#!

{"apiKey":{"id":1,"access_token":"h7Uty6gPo5eYyA3VQPd-4w","group":"hello"},"status":"created"}
```
--

* Make a GET request to the AdminController. A success message is returned since it isn't protected by an API Token.
```
#!

curl -X GET http://localhost:3000/admin -d ''
```

Expected response:

```
#!

{"message":"Congratulations!! You are authorized!"}
```

--

* Make a POST request to the AdminController. A failure message is returned since its a protected API.

```
#!

curl -X POST http://localhost:3000/admin -d ''
```

  Expected response:

```
#!

{"error":"Sorry!! You are not authorized!"}
```

--

* Including API Token in the header along with the scope id, should let the call authenticated and hence the success message is returned.

```
#!

curl -X POST http://localhost:3000/admin -d 'scope_id=<id>' -H "X-API-TOKEN: <Token>"
```

  Expected response:

```
#!

{"message":"Congratulations!! You are authorized!"}
```