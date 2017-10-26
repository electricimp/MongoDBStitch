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

#require "MongoDBStitch.agent.lib.nut:1.0.0"

// MongoDBStitch library sample. 
// Periodically receives new data from MongoDB and confirms data receiving 
// using pre-configured MongoDB Stitch named pipelines.
// Data are received every 15 seconds and printed to the log.

const MONGO_DB_STITCH_FIND_DATA_PIPELINE = "testFindData";
const MONGO_DB_STITCH_CONFIRM_DATA_PIPELINE = "testConfirmData";
const RECEIVE_DATA_PERIOD = 15.0;

class DataReceiver {
    _stitchClient = null;
    _apiKey = null;

    constructor(appId, apiKey) {
        _stitchClient = MongoDBStitch(appId);
        _apiKey = apiKey;
    }

    // Periodically receives new data from MongoDB and confirms data receiving using
    // pre-configured MongoDB Stitch named pipeline
    function receiveData() {
        _stitchClient.executeNamedPipeline(
            MONGO_DB_STITCH_FIND_DATA_PIPELINE,
            null,
            function (error, response) {
                if (error) {
                    server.error("Data receiving failed: " + error.details);
                } else {
                    local records = response.result[0];
                    if (records.len() > 0) {
                        local ids = [];
                        server.log("Data received:");
                        foreach (record in records) {
                            server.log(http.jsonencode(record.data));
                            ids.push(record._id);
                        }
                        // Confirm data receiving
                        _stitchClient.executeNamedPipeline(
                            MONGO_DB_STITCH_CONFIRM_DATA_PIPELINE,
                            { "ids" : ids },
                            function (error, response) {
                                if (error) {
                                    server.error("Confirm data receiving failed: " + error.details);
                                }
                            }.bindenv(this));
                    } else {
                        server.log("No new data received");
                    }
                }
            }.bindenv(this));

        imp.wakeup(RECEIVE_DATA_PERIOD, function () {
            receiveData();
        }.bindenv(this));
    }

    // Logins to the Stitch application and starts data receiving
    function start() {
        _stitchClient.loginWithApiKey(_apiKey, function (error, response) {
            if (error) {
                server.error("MongoDB Stitch authentication failed: " + error.details);
            } else {
                receiveData();
            }
        }.bindenv(this));
    }
}

// RUNTIME
// ---------------------------------------------------------------------------------

// MONGO DB STITCH CONSTANTS
// ----------------------------------------------------------
const MONGO_DB_STITCH_APPLICATION_ID = "<YOUR_STITCH_APPLICATION_ID>";
const MONGO_DB_STITCH_API_KEY = "<YOUR_STITCH_API_KEY>";

// Start application
dataReceiver <- DataReceiver(MONGO_DB_STITCH_APPLICATION_ID, MONGO_DB_STITCH_API_KEY);
dataReceiver.start();
