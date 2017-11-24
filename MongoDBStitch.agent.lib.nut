// MIT License
//
// Copyright 2017 Electric Imp
//
// SPDX-License-Identifier: MIT
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

// MongoDBStitch library provides an integration with MongoDB Stitch service
// (https://www.mongodb.com/cloud/stitch)
//
// The current library version supports the following functionality:
// - login to MongoDB Stitch using an application API key
// - executing MongoDB Stitch Functions

// MongoDBStitch library operation error types
enum MONGO_DB_STITCH_ERROR {
    // the library detects an error, e.g. the library is wrongly initialized or
    // a method is called with invalid argument(s).
    // The error details can be found in the error.details value
    LIBRARY_ERROR,
    // HTTP request to MongoDB Stitch service failed. The error details can be found in
    // the error.httpStatus and error.httpResponse properties
    MONGO_DB_STITCH_REQUEST_FAILED,
    // Unexpected response from MongoDB Stitch service. The error details can be found in
    // the error.details and error.httpResponse properties
    MONGO_DB_STITCH_UNEXPECTED_RESPONSE
};

// Error details produced by the library
const MONGO_DB_STITCH_UNAUTHORIZED = "Unauthorized request";
const MONGO_DB_STITCH_REQUEST_FAILED = "MongoDB Stitch request failed with status code";
const MONGO_DB_STITCH_REFRESH_TOKEN_FAILED = "MongoDB Stitch refresh token request failed";
const MONGO_DB_STITCH_NON_EMPTY_ARG = "Non empty argument required";

// Auxiliary class, represents error returned by the library.
class MongoDBStitchError {
    // error type, one of the MONGO_DB_STITCH_ERROR enum values
    type = null;

    // error details (string)
    details = null;

    // HTTP status code (integer),
    // null if type is MONGO_DB_STITCH_ERROR.LIBRARY_ERROR
    httpStatus = null;

    // Response body of failed request (table),
    // null if type is MONGO_DB_STITCH_ERROR.LIBRARY_ERROR
    httpResponse = null;

    constructor(type, details, httpStatus = null, httpResponse = null) {
        this.type = type;
        this.details = details;
        this.httpStatus = httpStatus;
        this.httpResponse = httpResponse;
    }
}

// Internal MongoDBStitch library constants
const _MONGO_DB_STITCH_BASE_URL = "https://stitch.mongodb.com/api/client/v2.0";

class MongoDBStitch {
    static VERSION = "1.0.0";

    _appId = null;
    _appPath = null;
    _accessToken = null;
    _refreshToken = null;
    _debug = null;

    // MongoDBStitch constructor.
    //
    // Parameters:
    //     appId : string            The Stitch application's ID.
    //
    // Returns:                      MongoDBStitch instance created.
    constructor(appId) {
        _appId = appId;
        if (appId) {
            _appPath = format("/app/%s", appId);
        }
    }

    // Login to the Stitch application using an API key.
    // Authentication is required every time the library is restarted.
    //
    // Parameters:
    //     apiKey : string           API key for the authentication.
    //     callback : function       Optional callback function executed once the operation
    //         (optional)            is completed.
    //                               The callback signature:
    //                               callback(error, response), where
    //                                   error :               Error details,
    //                                     MongoDBStitchError  null if the operation succeeds.
    //                                   response :            Body of the HTTP response received
    //                                     table               from MongoDB Stitch service,
    //                                                         decoded from JSON.
    //
    // Returns:                      Nothing
    function loginWithApiKey(apiKey, callback = null) {
        local error = _validateNonEmptyArg(apiKey, "apiKey");
        if (error) {
            _invokeCallback(error, null, callback);
            return;
        }

        _processRequest(
            "POST",
            _appPath + "/auth/providers/api-key/login",
            { "key" : apiKey },
            { "isAuth" : true },
            callback);
    }

    // Executes the specified MongoDB Stitch Function.
    // The Function should exist in the Stitch application.
    //
    // Parameters:
    //     name : string             Name of the Function.
    //     args : array of any type  Input parameters for the Function.
    //         (optional)
    //     callback : function       Optional callback function executed once the operation
    //         (optional)            is completed.
    //                               The callback signature:
    //                               callback(error, response), where
    //                                   error :               Error details,
    //                                     MongoDBStitchError  null if the operation succeeds.
    //                                   response :            Body of the HTTP response received
    //                                     table               from MongoDB Stitch service,
    //                                                         decoded from JSON.
    //
    // Returns:                      Nothing
    function executeFunction(name, args = null, callback = null) {
        local error = _validateNonEmptyArg(name, "name");
        if (error) {
            _invokeCallback(error, null, callback);
            return;
        }
        if (args == null) {
            args = [];
        }
        local body = {
            "name" : name,
            "arguments" : args
        };
        _processRequest("POST", _appPath + "/functions/call", body, null, callback);
    }

    // Enables/disables the library debug output (including errors logging).
    // Disabled by default.
    //
    // Parameters:
    //     value : boolean           true to enable, false to disable
    //
    // Returns:                      Nothing
    function setDebug(value) {
        _debug = value;
    }

    // -------------------- PRIVATE METHODS -------------------- //

    // Retrieves a new access token from refresh token
    function _refreshAccessToken(callback) {
        _processRequest("POST", "/auth/session", null, { "isAuth" : true, "useRefreshToken" : true }, callback);
    }

    // Sends an http request to MongoDB Stitch service
    function _processRequest(method, path, body, options, callback) {
        local error = _validateNonEmptyArg(_appId, "appId");
        if (error) {
            _invokeCallback(error, null, callback);
            return;
        }

        if (!options) {
            options = {};
        }
        local url = _MONGO_DB_STITCH_BASE_URL + path;
        local headers = {
            "Accept" : "application/json",
            "Content-Type" : "application/json"
        };
        local isAuth = _getTableValue(options, "isAuth", false);
        local useRefreshToken = _getTableValue(options, "useRefreshToken", false);
        if (!isAuth || useRefreshToken) {
            local token = useRefreshToken ? _refreshToken : _accessToken;
            if (!token) {
                _invokeCallback(
                    MongoDBStitchError(MONGO_DB_STITCH_ERROR.LIBRARY_ERROR, MONGO_DB_STITCH_UNAUTHORIZED),
                    null,
                    callback);
                return;
            }
            headers.Authorization <- format("Bearer %s", token);
        }
        if (!isAuth && _getTableValue(options, "refreshOnFailure", null) == null) {
            options.refreshOnFailure <- true;
        }

        _logDebug(format("Doing the request: %s %s, body: %s", method, url, http.jsonencode(body)));

        local request = http.request(method, url, headers, body ? http.jsonencode(body) : "");
        request.sendasync(function (response) {
            _processResponse(response, method, path, body, options, callback);
        }.bindenv(this));
    }

    // Processes http response from MongoDB Stitch service and executes callback if specified
    function _processResponse(response, method, path, body, options, callback) {
        _logDebug(format("Response status: %d, body: %s", response.statuscode, response.body));
        local errType = null;
        local errDetails = null;
        local httpStatus = response.statuscode;
        if (httpStatus < 200 || httpStatus >= 300) {
            errType = MONGO_DB_STITCH_ERROR.MONGO_DB_STITCH_REQUEST_FAILED;
            errDetails = format("%s: %i", MONGO_DB_STITCH_REQUEST_FAILED, httpStatus);
        }
        try {
            response.body = (response.body == "") ? {} : http.jsondecode(response.body);
        } catch (e) {
            if (!errType) {
                errType = MONGO_DB_STITCH_ERROR.MONGO_DB_STITCH_UNEXPECTED_RESPONSE;
                errDetails = e;
            }
        }
        
        // try to refresh token in case it is expired
        if (errType == MONGO_DB_STITCH_ERROR.MONGO_DB_STITCH_REQUEST_FAILED
            && httpStatus == 401 && _getTableValue(response.body, "error_code", null) == "InvalidSession"
            && _getTableValue(options, "refreshOnFailure", false)) {
            _refreshAccessToken(function (error, response) {
                if (error) {
                    error.details = MONGO_DB_STITCH_REFRESH_TOKEN_FAILED;
                    _invokeCallback(error, response, callback);
                } else {
                    options.refreshOnFailure = false;
                    _processRequest(method, path, body, options, callback);
                }
            }.bindenv(this));
        } else {
            local error = errType ? MongoDBStitchError(errType, errDetails, httpStatus, response.body) : null;
            if (!error && _getTableValue(options, "isAuth", false)) {
                _setTokens(response.body);
            }
            _invokeCallback(error, response.body, callback);
        }
    }

    // Logs error occurred and executes callback with default parameters if specified
    function _invokeCallback(error, response, callback) {
        if (error) {
            _logError(error.details);
        }
        if (callback) {
            imp.wakeup(0, function () {
                callback(error, response);
            });
        }
    }

    // Saves access and refresh tokens from response
    function _setTokens(response) {
        local accessToken = _getTableValue(response, "access_token", null);
        if (accessToken) {
            _accessToken = accessToken;
        }
        local refreshToken = _getTableValue(response, "refresh_token", null);
        if (refreshToken) {
            _refreshToken = refreshToken;
        }
    }

    // Returns value of specified table key, if exists or defaultValue
    function _getTableValue(table, key, defaultValue) {
        return (table && key in table) ? table[key] : defaultValue;
    }

    // Validates the argument is not empty. Returns MONGO_DB_STITCH_ERROR.LIBRARY_ERROR if the check failed
    function _validateNonEmptyArg(param, paramName, logError = true) {
        if (param == null || typeof param == "string" && param.len() == 0) {
            return MongoDBStitchError(
                MONGO_DB_STITCH_ERROR.LIBRARY_ERROR,
                format("%s: %s", MONGO_DB_STITCH_NON_EMPTY_ARG, paramName));
        }
        return null;
    }

    // Logs an error occurred during the library methods execution
    function _logError(message) {
        if (_debug) {
            server.error("[MongoDBStitch] " + message);
        }
    }

    // Logs an debug messages occurred during the library methods execution
    function _logDebug(message) {
        if (_debug) {
            server.log("[MongoDBStitch] " + message);
        }
    }
}
