# API Key Management Protocol #
 
##Generating an API key to Grant Access##
---
###Description###
This endpoint is for generating new API keys. 

###Endpoint###

    POST /security/api_keys

###Headers###

| Header Param Name    | Required  | Description  |
| ------------- |------------- | --------- | --------- |
| X-API-TOKEN      | yes | The api token of an APIKey in the master_key group. This is generated from seeding the db or a db migration |

    
###Parameters###

| Param Name    | Type        | Required  | Description  |
| ------------- |------------- | --------- | --------- |
| group      | string | yes | the name of a collection of controllers to grant access. Not providing a group will grant access to all public APIs |

###Responses###

| Response Code | Description |
| ------------- |------------ |
| 201           | Created     |
 
 _Example_     
```json
    {
        "api_key":{
                    "id":1,
                    "api_token":"h7Uty6gPo5eYyA3VQPd-4w",
                    "group":"messaging"
                 },
        "status":"created"
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

    DELETE /security/api_keys
    
###Parameters###

| Param Name    | Type        | Required  | Description  |
| ------------- |------------- | --------- | --------- |
| api_token      | string | yes | A string associated with the access token of an API Key |

###Responses###

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
