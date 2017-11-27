# MongoDBStitch #

This library allows your agent code to work with the [MongoDB Stitch service](https://www.mongodb.com/cloud/stitch).

This version of the library supports the following functionality:

- Login to MongoDB Stitch using an application API key.
- Executing a MongoDB Function.

**To add this library to your project, add** `#require "MongoDBStitch.agent.lib.nut:1.0.0"` **to the top of your agent code.**

## Library Usage ##

### Prerequisites ###

Before using the library you need to have:

- The ID of the Stitch application (see [‘How to create a Stitch app’](https://docs.mongodb.com/stitch/getting-started)).
- The API key of the Stitch application (see [‘How to enable and configure API key authentication’](https://docs.mongodb.com/stitch/auth/apikey-auth)).
- If your imp application uses MongoDB Functions, the name(s) of the Function(s) and knowledge of their input parameters and response (see [‘Functions overview’](https://docs.mongodb.com/stitch/functions/)).

### Callbacks ###

All requests that are made to the MongoDB Stitch service occur asynchronously. Every method that sends a request has an optional parameter which takes a callback function that will be executed when the operation is completed, whether successfully or not. The callbacks’ parameters are listed in the corresponding method description, but every callback has at least one parameter, *error*. If *error* is `null`, the operation has been executed successfully. Otherwise, *error* is an instance of the [MongoDBStitchError](#mongodbstitcherror-class) class and contains the details of the error.

## MongoDBStitch Class Usage ##

### Constructor: MongoDBStitch(*appId*) ###

| Parameter | Data Type | Required? | Description |
| --- | --- | --- | --- |
| *appId* | String | Yes | The Stitch application’s ID |

This method returns a new *MongoDBStitch* instance.

## MongoDBStitch Class Methods ##

### loginWithApiKey(*apiKey[, callback]*) ###

This method logs the agent into to the Stitch application. Authentication is by API key and is required every time the library is restarted.

| Parameter | Data Type | Required? | Description |
| --- | --- | --- | --- |
| *apiKey* | String | Yes | The Stitch application’s API key |
| *callback* | Function | Optional | Executed once the operation is completed |

This method returns nothing. The result of the operation may be obtained via the *callback* function, which has the following parameters:

| Parameter | Data Type | Description |
| --- | --- | --- |
| *error* | MongoDBStitchError | Error details, or `null` if the operation succeeds |
| *response* | Table | The body of the HTTP response received from the MongoDB Stitch service after it has been decoded from JSON into a table. The table’s keys are strings; their values may be any type |

### executeFunction(*name[, args][, callback]*) ###

This method executes the specified MongoDB Function. The Function should already exist in the Stitch application.

| Parameter | Data Type | Required? | Description |
| --- | --- | --- | --- |
| *name* | String | Yes | The name of the Function |
| *args* | Array of any type | Optional | Input parameters for the Function |
| *callback* | Function | Optional | Executed once the operation is completed |

This method returns nothing. The result of the operation may be obtained via the *callback* function, which has the following parameters:

| Parameter | Data Type | Description |
| --- | --- | --- |
| *error* | MongoDBStitchError | Error details, or `null` if the operation succeeds |
| *response* | Table | The body of the HTTP response received from the MongoDB Stitch service after it has been decoded from JSON into a table. The table’s keys are strings; their values may be any type |

### setDebug(*value*) ###

This method enables (*value* is `true`) or disables (*value* is `false`) the library debug output (including error logging). It is disabled by default. The method returns nothing.

## MongoDBStitchError Class ##

This class represents an error returned by the library and has the following public properties:

- *type* &mdash; The error type, which is one of the following *MONGO_DB_STITCH_ERROR* enum values:
    - *MONGO_DB_STITCH_ERROR.LIBRARY_ERROR* &mdash; The library is wrongly initialized, a method is called with invalid argument(s), or an internal error has occurred. The error details can be found in the *details* property. Usually this indicates an issue during an application development which should be fixed during debugging and therefore should not occur after the application has been deployed.
    - *MONGO_DB_STITCH_ERROR.PUB_SUB_REQUEST_FAILED* &mdash; An HTTP request to MongoDB Stitch service failed. The error details can be found in the *details*, *httpStatus* and *httpResponse* properties. This error may occur during the normal execution of an application. The application logic should process this error.
   - *MONGO_DB_STITCH_ERROR.PUB_SUB_UNEXPECTED_RESPONSE* &mdash; An unexpected response from the MongoDB Stitch service. The error details can be found in the *details* and *httpResponse* properties.
- *details* &mdash; A string with human readable details of the error.
- *httpStatus* &mdash; An integer indicating the HTTP status code, or `null` if *type* is *MONGO_DB_STITCH_ERROR.LIBRARY_ERROR*
- *httpResponse* &mdash; A table of key-value strings holding the response body of the failed request, or `null` if *type* is *MONGO_DB_STITCH_ERROR.LIBRARY_ERROR*.

## Examples ##

Working examples are provided in the [Examples](./Examples) directory and described [here](./Examples/README.md).

## License

The MongoDB Stitch library is licensed under the [MIT License](./LICENSE)
