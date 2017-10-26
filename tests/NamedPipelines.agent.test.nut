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

const DELETE_DATA_PIPELINE_NAME = "imptestDeleteData";
const DELETE_ONE_PIPELINE_NAME =  "imptestDeleteOne";
const FIND_DATA_PIPELINE_NAME   = "imptestFindData";
const INSERT_DATA_PIPELINE_NAME = "imptestInsertData";
const UPDATE_DATA_PIPELINE_NAME = "imptestUpdateData";

// Test case for execution of MongoDBStitch named pipelines.
// Predefined pipelines covers all standard mongodb-atlas services: insert, update, find and delete.
class NamedPipelinesTestCase extends ImpTestCase {
    _recordId = null;
    _stitchClient = null;

    function setUp() {
        _recordId = 0;
        _stitchClient = MongoDBStitch(MONGO_DB_STITCH_APPLICATION_ID);
        return Promise(function (resolve, reject) {
            _stitchClient.loginWithApiKey(MONGO_DB_STITCH_API_KEY, function (error, response) {
                if (error) {
                    return reject("loginWithApiKey failed");
                }
                // clean up imptest data
                tearDown().
                    then(function (value) {
                        return resolve(value);
                    }.bindenv(this)).
                    fail(function (reason) {
                        return reject(reason);
                    }.bindenv(this));
            }.bindenv(this));
        }.bindenv(this));
    }

    function tearDown() {
        return Promise(function (resolve, reject) {
            _stitchClient.executeNamedPipeline(DELETE_DATA_PIPELINE_NAME, null, function (error, response) {
                if (error) {
                    return reject(DELETE_DATA_PIPELINE_NAME + " pipeline execution failed");
                } else {
                    return resolve("");
                }
            }.bindenv(this));
        }.bindenv(this));
    }

    function testInsertData() {
        local elementsNumber = 5;
        local startId = _recordId + 1;
        local arr = array(elementsNumber, 0);
        return Promise.all(arr.map(function (val) { return _insertData(); }.bindenv(this))).
            then(function (value) {
                local ids = [];
                for (local i = startId; i <= _recordId; i++) {
                    ids.push(i);
                }
                return Promise.all(ids.map(function (val) {
                    return _findDataById(val).
                        then(function (value) {
                            if (value.len() > 0) {
                                return Promise.resolve("");
                            } else {
                                return Promise.reject("inserted data not found");
                            }
                        }.bindenv(this)).
                        fail(function (reason) {
                            return Promise.reject(reason);
                        }.bindenv(this)
                    );
                }.bindenv(this)));
            }.bindenv(this)).
            fail(function (reason) {
                return Promise.reject(reason);
            }.bindenv(this));
    }

    function testUpdateData() {
        _insertData().
            then(function (value) {
                return Promise(function (resolve, reject) {
                    local id = _recordId.tostring()
                    local newValue = "test_value";
                    _stitchClient.executeNamedPipeline(UPDATE_DATA_PIPELINE_NAME, { "id" : id, "value" : newValue }, function (error, response) {
                        if (error) {
                            return reject(UPDATE_DATA_PIPELINE_NAME + " pipeline execution failed");
                        } else {
                            _findDataById(id).
                                then(function (value) {
                                    if (value.len() == 1 && value[0].value == newValue ) {
                                        return resolve("");
                                    } else {
                                        return reject("data update failed");
                                    }
                                }.bindenv(this)).
                                fail(function (reason) {
                                    return reject(reason);
                                }.bindenv(this));
                        }
                    }.bindenv(this));
                }.bindenv(this));
            }.bindenv(this)).
            fail(function (reason) {
                return Promise.reject(reason);
            }.bindenv(this));
    }

    function testDeleteData() {
        local elementsNumber = 5;
        local arr = array(elementsNumber, 0);
        return Promise.all(arr.map(function (val) { return _insertData(); }.bindenv(this))).then(
            function (value) {
                _stitchClient.executeNamedPipeline(DELETE_DATA_PIPELINE_NAME, null, function (error, response) {
                    if (error) {
                        return reject(DELETE_DATA_PIPELINE_NAME + " pipeline execution failed");
                    } else {
                        local ids = [];
                        for (local i = 1; i <= _recordId; i++) {
                            ids.push(i);
                        }
                        return Promise.all(ids.map(function (val) {
                            return _findDataById(val).then(
                                function (value) {
                                    if (value.len() > 0) {
                                        return Promise.reject("data not deleted");
                                    } else {
                                        return Promise.resolve("");
                                    }
                                }.bindenv(this),
                                function (reason) {
                                    return Promise.reject(reason);
                                }.bindenv(this)
                            );
                        }.bindenv(this)));
                    }
                }.bindenv(this));
            }.bindenv(this),
            function (reason) {
                return Promise.reject(reason);
            }.bindenv(this));
    }

    function testDeleteOne() {
        local elementsNumber = 5;
        local arr = array(elementsNumber, 0);
        return Promise.all(arr.map(function (val) { return _insertData(); }.bindenv(this))).then(
            function (value) {
                local testedId = _recordId - 1;
                _stitchClient.executeNamedPipeline(DELETE_ONE_PIPELINE_NAME, { "id" : testedId.tostring() }, function (error, response) {
                    if (error) {
                        return reject(DELETE_ONE_PIPELINE_NAME + " pipeline execution failed");
                    } else {
                        _findDataById(testedId).then(
                            function (value) {
                                if (value.len() > 0) {
                                    return Promise.reject("data not deleted");
                                } else {
                                    return Promise.resolve("");
                                }
                            }.bindenv(this),
                            function (reason) {
                                return Promise.reject(reason);
                            }.bindenv(this)
                        );
                    }
                }.bindenv(this));
            }.bindenv(this),
            function (reason) {
                return Promise.reject(reason);
            }.bindenv(this));
    }

    function _findDataById(id) {
        return Promise(function (resolve, reject) {
            _stitchClient.executeNamedPipeline(FIND_DATA_PIPELINE_NAME, { "id" : id.tostring() }, function (error, response) {
                if (error) {
                    return reject(FIND_DATA_PIPELINE_NAME + " pipeline execution failed");
                } else {
                    if (response && "result" in response && typeof response.result == "array") {
                        return resolve(response.result[0]);
                    } else {
                        return reject("unexpected format of response");
                    }
                }
            }.bindenv(this));
        }.bindenv(this));
    }

    function _insertData() {
        return Promise(function (resolve, reject) {
            _stitchClient.executeNamedPipeline(INSERT_DATA_PIPELINE_NAME, _getData(), function (error, response) {
                if (error) {
                    return reject(INSERT_DATA_PIPELINE_NAME + " pipeline execution failed");
                } else {
                    return resolve("");
                }
            }.bindenv(this));
        }.bindenv(this));
    }

    function _getData() {
        _recordId++;
        return { "id" : _recordId.tostring(), "value" : "val" + _recordId.tostring() };
    }
}
 