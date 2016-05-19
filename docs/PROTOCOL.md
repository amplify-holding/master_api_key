#API Key Management Protocol#
 
##Generating an API key to Grant Access##
---
###Description###
This endpoint is for generating new API keys. 

###Endpoint###

    POST <service_domain>/api_keys

###Headers###

| Header Param Name    | Required  | Description  |
| ------------- |------------- | --------- | --------- |
| X-API-TOKEN | yes | The api token of an APIKey in the master_key group. |

    
###Parameters###

| Param Name    | Type        | Required  | Description  |
| ------------- |------------- | --------- | --------- |
| group | string | yes | the name of a collection of controllers to grant access. Not providing a group will grant access to all public APIs |
| authorizations | json | yes | This is a json containing various authorizations fields for the api key. You'll need at least one authorization but are not required to have all of them. E.g. authorizations:{"read_access":true,"write_access":false} would give the api key read access but not write access to a controller. |

###Responses###

| Response Code | Description |
| ------------- |------------ |
| 201           | Created     |
| 400 | A required parameter is missing |
| 401           | Unauthorized     |
| 403           | Forbidden     |

 _Example_     
```json
{
    "api_key":{
                "id":1,
                "api_token":"h7Uty6gPo5eYyA3VQPd-4w",
                "group":"messaging",
                "read_access":true,
                "write_access":false
              }
}    
```

##Updating Access Rights for an API key##
---
###Description###
This endpoint will allow you to modify authorizations for an api key. he default authorizations are
read_access and write_access. The read_access field provides authorization to use the index and show action.
The write_access field provides authorization to use the edit, update, destroy, new, and create actions.

###Endpoint###

    PATCH <service_domain>/api_keys

###Headers###

| Header Param Name    | Required  | Description  |
| ------------- |------------- | --------- | --------- |
| X-API-TOKEN      | yes | The api token of an APIKey in the master_key group. |

    
###Parameters###

| Param Name    | Type        | Required  | Description  |
| ------------- |------------- | --------- | --------- |
| authorizations | json | yes | This is a json containing various authorizations fields for the api key. You'll need at least one authorization but are not required to have all of them. E.g. authorizations:{"read_access":true,"write_access":false} would give the api key read access but not write access to a controller. |

###Responses###

| Response Code | Description |
| ------------- |------------ |
| 200           | OK     |
| 400 | A required parameter is missing |
| 401           | Unauthorized     |
| 403           | Forbidden     |

 
 _Example_     
```json
{
    "api_key":{
                "id":1,
                "api_token":"h7Uty6gPo5eYyA3VQPd-4w",
                "group":"messaging",
                "read_access":true,
                "write_access":false
              }
}
```

##Deleting an API Key by Access Token##
---
###Description###

    Revokes access for anyone using the associated api key
    
###Headers###

| Header Param Name    | Required  | Description  |
| ------------- |------------- | --------- | --------- |
| X-API-TOKEN      | yes | The api token of an APIKey in the master_key group. This is generated from seeding the db or a db migration |

###Endpoint###

    DELETE <service_domain>/api_keys
    
###Parameters###

| Param Name    | Type        | Required  | Description  |
| ------------- |------------- | --------- | --------- |
| api_token      | string | yes | A string associated with the access token of an API Key |

###Responses###

| Response Code | Description  |
| ------------- |------------- |
| 200 | Success |
| 400 | A required parameter is missing |
| 401           | Unauthorized     |
| 403           | Forbidden     |
 
