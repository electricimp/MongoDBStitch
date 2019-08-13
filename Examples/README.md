# MongoDBStitch Examples #

This document describes the example applications provided with the [MongoDBStitch library](../README.md). The examples include:

- *DataSender* &mdash; sending data to MongoDB
- *DataReceiver* &mdash; receiving data from MongoDB and confirming the receipt

You should run the *DataReceiver* example after or in parallel with *DataSender* example. We recommend that you run *DataSender* on the agent of one imp and run *DataReceiver* on the agent of a second imp.

Each example is described first; you will find generic and example-specific [setup instructions](#using-the-examples) further down the page.

**Note** MongoDBStitch has made some updates to their web page, so screenshots in instructions may not match the current MongoDBStitch UI.

## DataSender ##

This example inserts data into a preconfigured MongoDB collection using a predefined MongoDB Stitch Function:

- Data is sent every ten seconds.
- Every data record contains:
    - A `"value"` attribute. This is an integer value, converted to string, which starts at 1 and increases by 1 with every record sent. It restarts from 1 every time the example is restarted.
    - A `"measureTime"` attribute. This is an integer value, converted to string, and is the time in seconds since the epoch.

![DataSender example](../png/SenderExample.png?raw=true)

## DataReceiver ##

This example receives new data from a preconfigured MongoDB collection and confirms data receipt using predefined MongoDB Stitch Functions:

- Data is received every 15 seconds.
- Every received data record is printed to the log.
- Data receipt is confirmed by updating the data’s `"received"` attribute using a predefined MongoDB Stitch Function.

![DataReceiver example](../png/ReceiverExample.png?raw=true)

## Using the Examples ##

1. In [Electric Imp’s IDE](https://ide.electricimp.com/) create two new Models, one for imp A (*DataSender*), the other for imp B (*DataReceiver*).
1. Copy the [*DataSender* source code](./DataSender.agent.nut) and paste it into the IDE as the agent code of imp A. Before running the code you will need to set the configuration constants as described in the [general setup](#setup-for-all-examples) below.
1. Copy the [*DataReceiver* source code](./DataReceiver.agent.nut) and paste it into the IDE as the agent code of imp B. Before running the code you will need to set the configuration constants as described in the [general setup](#setup-for-all-examples) below.
1. Perform the [general setup](#setup-for-all-examples) applicable for the both examples.
1. Perform [additional setup for the *DataSender* example](#additional-setup-for-datasender).
1. Perform [additional setup for the *DataReceiver* example](#additional-setup-for-datasender).
1. Build and Run *DataSender*.
1. Check from the logs in the IDE that data insertions are successful.
1. Build and Run *DataReceiver*.
1. Check from the logs that data is being received successfully.

You may skip the steps related to *DataReceiver* example if you are only trying the *DataSender* example.

## Setup For All Examples ##

### MongoDB Stitch Account Configuration ###

In this section the following MongoDB Stitch entities are created and configured:

- A MongoDB Atlas Cluster.
- A MongoDB Stitch Application.
- An API key authentication for the Stitch Application.
- A MongoDB Collection that will be used to store the Examples data.

### Create MongoDB Atlas Cluster ###

1. Login to your [MongoDB Atlas account](https://cloud.mongodb.com) in your web browser.
1. If you have an existing Atlas cluster that you want to work with, skip this step, otherwise: 
  1. Click **Clusters** in the **PROJECT** menu and click **Build a New Cluster**:
    ![Build a new cluster](../png/CreateCluster1.png?raw=true)
  1. In the **Build Your New Cluster** pop up:
    1. Optionally modify **Cluster Name**.
    1. Click **Select** for **M0 Instance Size**:
    ![Select M0 Cluster](../png/CreateCluster2.png?raw=true)
    1. Click **Confirm & Deploy**:
    ![Deploy Cluster](../png/CreateCluster3.png?raw=true)
    1. Wait until your Cluster is deployed. This may take several minutes.
    
### Create MongoDB Stitch Application ###

1. Click **Stitch Apps** in the **PROJECT** menu and click **Create New Application**:
![Create new app](../png/CreateApp1.png?raw=true)
1. In the **Create a new application** pop up:
  1. Enter **Application Name**, eg. `testApp`.
  1. Choose a **Cluster**.
  1. Click **Create**:
    ![Create app](../png/CreateApp2.png?raw=true)
  1. Wait until your Application is created. This may take several seconds.
1. You will be redirected to your Stitch Application page.
1. Click **Clients** in the application menu.
1. Copy (click **COPY**) the **App ID** of your Stitch application and paste into a plain text document or equivalent. This will be used as the value of the *MONGO_DB_STITCH_APPLICATION_ID* constant in the imp agent code:
![Copy app id](../png/CreateApp3.png?raw=true)

### Enable API Key Authentication for the Stitch Application ###

1. Click **Authentication** in the **CONTROL** menu.
1. Click **Edit** for **API Keys** provider:
  ![Edit Api Keys](../png/CreateApiKey1.png?raw=true)
1. In the **Edit Auth Provider** pop up:
  1. Set the **API Keys** switch to enabled.
  1. Click **CREATE API KEY**:
    ![Create Api Key](../png/CreateApiKey2.png?raw=true)
  1. Enter a name for the API key into the text input, eg. `test`.
  1. Click **Save**:
    ![Save Api Key](../png/CreateApiKey3.png?raw=true)
  1. Copy (click **COPY**) the ere **API key** of your Stitch application and paste into a plain text document or equivalent. This will be used as the value of the *MONGO_DB_STITCH_API_KEY* constant in the imp agent code:
    ![Copy Api Key](../png/CreateApiKey4.png?raw=true)
  1. Close the **Edit Auth Provider** pop up.

### Create a MongoDB Collection ###

1. Click **mongodb-atlas** in the **ATLAS CLUSTERS** menu and click **NEW** for **MongoDB Collections**:
![New Collection](../png/CreateCollection1.png?raw=true)
1. Enter `testdb` as the **Database** name and `data` as the **Collection** name.
1. Click **CREATE**:
![Create Collection](../png/CreateCollection2.png?raw=true)
1. Click to your newly created collection:
![Created Collection](../png/CreateCollection3.png?raw=true)
1. Click the **Top-Level Document** field:
![Top-Level Document](../png/CreateCollection4.png?raw=true)
1. Modify the **READ** permission on top-level document to `{}`.
1. Modify the **WRITE** permission on top-level document to `{}`.
1. Click **SAVE**:
![Top-Level Document Modification](../png/CreateCollection5.png?raw=true)
1. Click the **owner_id** field.
1. Click the **delete** (**X**) on the right-hand side:
![Delete owner_id](../png/CreateCollection6.png?raw=true)
1. In the confirmation popup click **Delete Field** to confirm the deletion of the **owner_id** field.
1. Click **SAVE**:
![Collection Rules](../png/CreateCollection7.png?raw=true)
1. Click the **Filters** tab.
1. Click **DELETE** for the existing filter and click **SAVE**:
![Collection Filters](../png/CreateCollection8.png?raw=true)

### Agent Constants Setup ###

1. Set the *MONGO_DB_STITCH_APPLICATION_ID* and *MONGO_DB_STITCH_API_KEY* constants in the agent example code to the values you copied and saved in the previous steps. Set the same values for both *DataSender* and *DataReceiver*:
![Configuration Constants](../png/ConstSetup.png?raw=true)

## Additional Setup for DataSender ##

This must be performed *before* you run *DataSender*. 

In this section, the following MongoDB Stitch entities are created and configured:

- The MongoDB Stitch Function *testInsertData* that will be used to store *DataSender* data in the MongoDB Collection configured in the previous steps.

### Create MongoDB Stitch Function: testInsertData ###

1. In your [MongoDB Atlas account](https://cloud.mongodb.com) select the Stitch Application you created in the previous steps.
1. Click **Functions** in the **CONTROL** menu and click **Create New Function**:
![New Function](../png/Sender1.png?raw=true)
1. Enter `testInsertData` into the **Function Name** field.
1. Click the **Function Editor** tab:
![testInsertData Function](../png/Sender2.png?raw=true)
1. Enter the following code into the Function Editor text field:
```
exports = function(data) {
  var collection = context.services.get("mongodb-atlas").db('testdb').collection('data');
  return collection.insertOne({ "data" : data, "received" : false });
};
```
1. Click **Save**:
![testInsertData code](../png/Sender3.png?raw=true)

## Additional Setup for DataReceiver ##

This must be performed *before* you run *DataReceiver*. 

In this section, the following MongoDB Stitch entities are created and configured:

- The MongoDB Stitch Function *testFindData* that will be used to receive data from the MongoDB Collection configured in the previous steps.
- The MongoDB Stitch Function *testConfirmData* that will be used to confirm the data has been received.

### Create MongoDB Stitch Function: testFindData ###

1. In your [MongoDB Atlas account](https://cloud.mongodb.com) select your Stitch Application, created during the previous steps.
1. Click **Functions** in the **CONTROL** menu and click **Create New Function**:
![New Function](../png/Receiver1.png?raw=true)
1. Enter `testFindData` into the **Function Name** field.
1. Click the **Function Editor** tab:
![testFindData Function](../png/Receiver2.png?raw=true)
1. Enter the following code into the Function Editor text field:
```
exports = function() {
  var collection = context.services.get("mongodb-atlas").db('testdb').collection('data');
  return collection.find({ "received" : false }).limit(10).toArray();
};
```
1. Click **Save**:
![testFindData code](../png/Receiver3.png?raw=true)

### Create MongoDB Stitch Function: testConfirmData ###

1. Click **Functions** in the **CONTROL** menu and click **Create New Function**:
![New Function](../png/Receiver4.png?raw=true)
1. Enter `testConfirmData` into the **Function Name** field.
1. Click **Function Editor** tab:
![testConfirmData Function](../png/Receiver5.png?raw=true)
1. Enter the following code into the Function Editor text field:
```
exports = function(ids) {
  var collection = context.services.get("mongodb-atlas").db('testdb').collection('data');
  return collection.updateMany({ "_id" : { "$in" : ids } }, { "$set" : { "received" : true } });
};
```
1. Click **Save**:
![testConfirmData code](../png/Receiver6.png?raw=true)
