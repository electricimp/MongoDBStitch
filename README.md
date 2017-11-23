# MongoDBStitch

This library lets your agent code to work with [MongoDB Stitch service](https://www.mongodb.com/cloud/stitch).

This version of the library supports the following functionality:

- login to MongoDB Stitch using an application API key
- executing a Function

**To add this library to your project, add** `#require "MongoDBStitch.agent.lib.nut:1.0.0"` **to the top of your agent code.**

## Prerequisites

Before using the library you need to have:

- id of the Stitch application ([how to create a Stitch App](https://docs.mongodb.com/stitch/getting-started))
- API key of the Stitch application ([how to enable and configure API Key Authentication](https://docs.mongodb.com/stitch/auth/apikey-auth))
- (if your IMP application uses Functions) name(s) of the Function(s) and knowledge about their input parameters and response ([Functions overview](https://docs.mongodb.com/stitch/functions/))

## Library Usage

### Callbacks

All requests that are made to the MongoDB Stitch service occur asynchronously. Every method that sends a request has an optional parameter which takes a callback function that will be called when the operation is completed, successfully or not. The callbacks’ parameters are listed in the corresponding method documentation, but every callback has at least one parameter, *error*. If *error* is `null`, the operation has been executed successfully. Otherwise, *error* is an instance of the [MongoDBStitchError](#mongodbstitcherror-class) class and contains the details of the error.

### MongoDBStitchError Class

Represents an error returned by the library and has the following public properties:

- *type* &mdash; The error type, which is one of the following *MONGO_DB_STITCH_ERROR* enum values:

  - *MONGO_DB_STITCH_ERROR.LIBRARY_ERROR* &mdash; The library is wrongly initialized, or a method is called with invalid argument(s), or an internal error. The error details can be found in the *details* property. Usually it indicates an issue during an application development which should be fixed during debugging and therefore should not occur after the application has been deployed.
  
  - *MONGO_DB_STITCH_ERROR.PUB_SUB_REQUEST_FAILED* &mdash; HTTP request to MongoDB Stitch service fails. The error details can be found in the *details*, *httpStatus* and *httpResponse* properties. This error may occur during the normal execution of an application. The application logic should process this error.
  
  - *MONGO_DB_STITCH_ERROR.PUB_SUB_UNEXPECTED_RESPONSE* &mdash; An unexpected response from MongoDB Stitch service. The error details can be found in the *details* and *httpResponse* properties.
  
- *details* &mdash; A string with human readable details of the error.

- *httpStatus* &mdash; An integer indicating the HTTP status code, or `null` if *type* is *MONGO_DB_STITCH_ERROR.LIBRARY_ERROR*

- *httpResponse* &mdash; A table of key-value strings holding the response body of the failed request, or `null` if *type* is *MONGO_DB_STITCH_ERROR.LIBRARY_ERROR*.

### MongoDBStitch Class

#### Constructor: MongoDBStitch(*appId*)

| Parameter | Data Type | Required? | Description |
| --- | --- | --- | --- |
| *appId* | String | Yes  | The Stitch application's ID |

Returns *MongoDBStitch* instance created.

#### loginWithApiKey(*apiKey[, callback]*)

Login to the Stitch application using an API key. Authentication is required every time the library is restarted.

| Parameter | Data Type | Required? | Description |
| --- | --- | --- | --- |
| *apiKey* | String | Yes | API key for the authentication |
| *callback* | Function | Optional | Executed once the operation is completed |

The method returns nothing. The result of the operation may be obtained via the *callback* function, which has the following parameters:

| Parameter | Data Type | Description |
| --- | --- | --- |
| *error* | MongoDBStitchError | Error details, or `null` if the operation succeeds |
| *response* | Table | Body of the HTTP response received from MongoDB Stitch service. Decoded from JSON. Key-value table, where key is a string, value is any type |

#### executeFunction(*name[, args][, callback]*)

Execute the specified Function. The Function should exist in the Stitch application.

| Parameter | Data Type | Required? | Description |
| --- | --- | --- | --- |
| *name* | String | Yes | Name of the Function |
| *args* | Array of any type | Optional | Input parameters for the Function |
| *callback* | Function | Optional | Executed once the operation is completed |

The method returns nothing. The result of the operation may be obtained via the *callback* function, which has the following parameters:

| Parameter | Data Type | Description |
| --- | --- | --- |
| *error* | MongoDBStitchError | Error details, or `null` if the operation succeeds |
| *response* | Table | Body of the HTTP response received from MongoDB Stitch service. Decoded from JSON. Key-value table, where key is a string, value is any type |

#### setDebug(*value*)

This method enables (*value* = `true`) or disables (*value* = `false`) the library debug output (including error logging). It is disabled by default. The method returns nothing.

## Examples

Working examples are provided in the [Examples](./Examples) directory and described [here](./Examples/README.md).

## License

The MongoDB Stitch library is licensed under the [MIT License](./LICENSE)
