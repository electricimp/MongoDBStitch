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
// Periodically sends data to MongoDB using pre-configured MongoDB Stitch Function.
// Data are sent every 10 seconds, they consist of integer increasing value, converted to string
// and measureTime attribute with data measurement time in seconds since the epoch format.

const MONGO_DB_STITCH_INSERT_DATA_FUNCTION = "testInsertData";
const SEND_DATA_PERIOD = 10.0;

class DataSender {
    _counter = 0;
    _stitchClient = null;
    _apiKey = null;

    constructor(appId, apiKey) {
        _stitchClient = MongoDBStitch(appId);
        _apiKey = apiKey;
    }

    // Returns a data to be sent
    function getData() {
        _counter++;
        return {
            "value" : _counter.tostring(),
            "measureTime" : time().tostring()
        };
    }

    // Periodically sends data to MongoDB using pre-configured MongoDB Stitch Function
    function sendData() {
        local data = getData();
        _stitchClient.executeFunction(
            MONGO_DB_STITCH_INSERT_DATA_FUNCTION,
            [ data ],
            function (error, response) {
                if (error) {
                    server.error("Data insertion failed: " + error.details);
                } else {
                    server.log("Data inserted successfully:");
                    server.log(http.jsonencode(data));
                }
            }.bindenv(this));

        imp.wakeup(SEND_DATA_PERIOD, function () {
            sendData();
        }.bindenv(this));
    }

    // Logins to the Stitch application and starts data sending
    function start() {
        _stitchClient.loginWithApiKey(_apiKey, function (error, response) {
            if (error) {
                server.error("MongoDB Stitch authentication failed: " + error.details);
            } else {
                sendData();
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
dataSender <- DataSender(MONGO_DB_STITCH_APPLICATION_ID, MONGO_DB_STITCH_API_KEY);
dataSender.start();
