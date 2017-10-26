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

const MONGO_DB_STITCH_APPLICATION_ID = "@{MONGO_DB_STITCH_APPLICATION_ID}";
const MONGO_DB_STITCH_API_KEY        = "@{MONGO_DB_STITCH_API_KEY}";

// Test case for wrong parameters of MongoDBStitch library methods.
class WrongParamsTestCase extends ImpTestCase {
    
    function testWrongAppId() {
        return Promise.all([
            _testWrongAppId(null),
            _testWrongAppId("")
        ]);
    }

    function testWrongApiKey() {
        return Promise.all([
            _testWrongApiKey(null),
            _testWrongApiKey("")
        ]);
    }

    function testWrongPipelineName() {
        return Promise.all([
            _testWrongPipelineName(null),
            _testWrongPipelineName("")
        ]);
    }

    function testExecutePipelineWithoutLogin() {
        local _stitchClient = MongoDBStitch(MONGO_DB_STITCH_APPLICATION_ID);
        return Promise(function (resolve, reject) {
            _stitchClient.executeNamedPipeline("__test", null, function (error, response) {
                if (!_isLibraryError(error)) {
                    return reject("execute pipeline without login accepted");
                }
                return resolve("");
            }.bindenv(this));
        }.bindenv(this));
    }

    function testNonexistentAppId() {
        local _stitchClient = MongoDBStitch("__test");
        return Promise(function (resolve, reject) {
            _stitchClient.loginWithApiKey(MONGO_DB_STITCH_API_KEY, function (error, response) {
                if (!_isRequestFailedError(error)) {
                    return reject("wrong error type for nonexistent app id");
                }
                return resolve("");
            }.bindenv(this));
        }.bindenv(this));
    }

    function testNonexistentApiKey() {
        local _stitchClient = MongoDBStitch(MONGO_DB_STITCH_APPLICATION_ID);
        return Promise(function (resolve, reject) {
            _stitchClient.loginWithApiKey("__test", function (error, response) {
                if (!_isRequestFailedError(error)) {
                    return reject("wrong error type for nonexistent api key");
                }
                return resolve("");
            }.bindenv(this));
        }.bindenv(this));
    }

    function testNonexistentPipelineName() {
        local _stitchClient = MongoDBStitch(MONGO_DB_STITCH_APPLICATION_ID);
        return Promise(function (resolve, reject) {
            _stitchClient.loginWithApiKey(MONGO_DB_STITCH_API_KEY, function (error, response) {
                if (error) {
                    return reject("login failed");
                }
                _stitchClient.executeNamedPipeline("__test", null, function (error, response) {
                    if (!_isRequestFailedError(error)) {
                        return reject("wrong error type for nonexistent pipeline name");
                    }
                    return resolve("");
                }.bindenv(this));
            }.bindenv(this));
        }.bindenv(this));
    }

    function _testWrongAppId(appId) {
        local _stitchClient = MongoDBStitch(appId);
        return Promise(function (resolve, reject) {
            _stitchClient.loginWithApiKey(MONGO_DB_STITCH_API_KEY, function (error, response) {
                if (!_isLibraryError(error)) {
                    return reject("wrong appId accepted in loginWithApiKey: '" + appId + "'");
                }
                _stitchClient.executeNamedPipeline("__test", null, function (error, response) {
                    if (!_isLibraryError(error)) {
                        return reject("wrong appId accepted in executeNamedPipeline: '" + appId + "'");
                    }
                    return resolve("");
                }.bindenv(this));
            }.bindenv(this));
        }.bindenv(this));
    }

    function _testWrongApiKey(apiKey) {
        local _stitchClient = MongoDBStitch(MONGO_DB_STITCH_APPLICATION_ID);
        return Promise(function (resolve, reject) {
            _stitchClient.loginWithApiKey(apiKey, function (error, response) {
                if (!_isLibraryError(error)) {
                    return reject("wrong api key accepted: '" + apiKey + "'");
                }
                return resolve("");
            }.bindenv(this));
        }.bindenv(this));
    }

    function _testWrongPipelineName(pipelineName) {
        local _stitchClient = MongoDBStitch(MONGO_DB_STITCH_APPLICATION_ID);
        return Promise(function (resolve, reject) {
            _stitchClient.loginWithApiKey(MONGO_DB_STITCH_API_KEY, function (error, response) {
                if (error) {
                    return reject("login failed");
                }
                _stitchClient.executeNamedPipeline(pipelineName, null, function (error, response) {
                    if (!_isLibraryError(error)) {
                        return reject("wrong pipeline name accepted: '" + pipelineName + "'");
                    }
                    return resolve("");
                }.bindenv(this));
            }.bindenv(this));
        }.bindenv(this));
    }

    function _isLibraryError(error) {
        return error && error.type == MONGO_DB_STITCH_ERROR.LIBRARY_ERROR;
    }

    function _isRequestFailedError(error) {
        return error && error.type == MONGO_DB_STITCH_ERROR.MONGO_DB_STITCH_REQUEST_FAILED;
    }    
}
