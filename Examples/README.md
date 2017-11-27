# MongoDBStitch Examples #

This document describes the example applications provided with the [MongoDBStitch library](../README.md). The examples include:

- *DataSender* &mdash; sending data to MongoDB
- *DataReceiver* &mdash; receiving data from MongoDB and confirming the receipt

You should run the *DataReceiver* example after or in parallel with *DataSender* example. We recommend that you run *DataSender* on the agent of one imp and run *DataReceiver* on the agent of a second imp.

Each example is described first; you will find generic and example-specific [setup instructions](#examples-setup-and-run) further down the page.

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

- In [Electric Imp’s IDE](https://ide.electricimp.com/) create two new Models, one for imp A (*DataSender*), the other for imp B (*DataReceiver*).
- Copy the [*DataSender* source code](./DataSender.agent.nut) and paste it into the IDE as the agent code of imp A. Before running the code you will need to set the configuration constants as described in the [general setup](#setup-for-all-examples) below.
- Copy the [*DataReceiver* source code](./DataReceiver.agent.nut) and paste it into the IDE as the agent code of imp B. Before running the code you will need to set the configuration constants as described in the [general setup](#setup-for-all-examples) below.
- Perform the [general setup](#setup-for-all-examples) applicable for the both examples.
- Perform [additional setup for the *DataSender* example](#additional-setup-for-datasender-example).
- Perform [additional setup for the *DataReceiver* example](#additional-setup-for-datareceiver-example).
- Build and Run *DataSender*.
- Check from the logs in the IDE that data insertions are successful.
- Build and Run *DataReceiver*.
- Check from the logs that data is being received successfully.

You may skip the steps related to *DataReceiver* example if you are only trying the *DataSender* example.

## Setup For All Examples ##

### MongoDB Stitch Account Configuration ###

In this section the following MongoDB Stitch entities are created and configured:

- A MongoDB Atlas Cluster.
- A MongoDB Stitch Application.
- An API key authentication for the Stitch Application.
- A MongoDB Collection that will be used to store the Examples data.

### Create MongoDB Atlas Cluster ###

- Login to your [MongoDB Atlas account](https://cloud.mongodb.com) in your web browser.
- If you have an existing Atlas cluster that you want to work with, skip this step, otherwise: 
  - Click **Clusters** in the **PROJECT** menu and click **Build a New Cluster**:
    ![Build a new cluster](../png/CreateCluster1.png?raw=true)
  - In the **Build Your New Cluster** pop up:
    - Optionally modify **Cluster Name**.
    - Click **Select** for **M0 Instance Size**:
    ![Select M0 Cluster](../png/CreateCluster2.png?raw=true)
    - Click **Confirm & Deploy**:
    ![Deploy Cluster](../png/CreateCluster3.png?raw=true)
    - Wait until your Cluster is deployed. This may take several minutes.
    
### Create MongoDB Stitch Application ###

- Click **Stitch Apps** in the **PROJECT** menu and click **Create New Application**:
![Create new app](../png/CreateApp1.png?raw=true)
- In the **Create a new application** pop up:
  - Enter **Application Name**, eg. `testApp`.
  - Choose a **Cluster**.
  - Click **Create**:
    ![Create app](../png/CreateApp2.png?raw=true)
  - Wait until your Application is created. This may take several seconds.
- You will be redirected to your Stitch Application page.
- Click **Clients** in the application menu.
- Copy (click **COPY**) the **App ID** of your Stitch application and paste into a plain text document or equivalent. This will be used as the value of the *MONGO_DB_STITCH_APPLICATION_ID* constant in the imp agent code:
![Copy app id](../png/CreateApp3.png?raw=true)

### Enable API Key Authentication for the Stitch Application ###

- Click **Authentication** in the **CONTROL** menu.
- Click **Edit** for **API Keys** provider:
  ![Edit Api Keys](../png/CreateApiKey1.png?raw=true)
- In the **Edit Auth Provider** pop up:
  - Set the **API Keys** switch to enabled.
  - Click **CREATE API KEY**:
    ![Create Api Key](../png/CreateApiKey2.png?raw=true)
  - Enter a name for the API key into the text input, eg. `test`.
  - Click **Save**:
    ![Save Api Key](../png/CreateApiKey3.png?raw=true)
  - Copy (click **COPY**) the ere **API key** of your Stitch application and paste into a plain text document or equivalent. This will be used as the value of the *MONGO_DB_STITCH_API_KEY* constant in the imp agent code:
    ![Copy Api Key](../png/CreateApiKey4.png?raw=true)
  - Close the **Edit Auth Provider** pop up.

### Create a MongoDB Collection ###

- Click **mongodb-atlas** in the **ATLAS CLUSTERS** menu and click **NEW** for **MongoDB Collections**:
![New Collection](../png/CreateCollection1.png?raw=true)
- Enter `testdb` as the **Database** name and `data` as the **Collection** name.
- Click **CREATE**:
![Create Collection](../png/CreateCollection2.png?raw=true)
- Click to your newly created collection:
![Created Collection](../png/CreateCollection3.png?raw=true)
- Click the **Top-Level Document** field:
![Top-Level Document](../png/CreateCollection4.png?raw=true)
- Modify the **READ** permission on top-level document to `{}`.
- Modify the **WRITE** permission on top-level document to `{}`.
- Click **SAVE**:
![Top-Level Document Modification](../png/CreateCollection5.png?raw=true)
- Click the **owner_id** field.
- Click the **delete** (**X**) on the right-hand side:
![Delete owner_id](../png/CreateCollection6.png?raw=true)
- In the confirmation popup click **Delete Field** to confirm the deletion of the **owner_id** field.
- Click **SAVE**:
![Collection Rules](../png/CreateCollection7.png?raw=true)
- Click the **Filters** tab.
- Click **DELETE** for the existing filter and click **SAVE**:
![Collection Filters](../png/CreateCollection8.png?raw=true)

### Agent Constants Setup ###

- Set the *MONGO_DB_STITCH_APPLICATION_ID* and *MONGO_DB_STITCH_API_KEY* constants in the agent example code to the values you copied and saved in the previous steps. Set the same values for both *DataSender* and *DataReceiver*:
![Configuration Constants](../png/ConstSetup.png?raw=true)

## Additional Setup for DataSender ##

This must be performed *before* you run *DataSender*. 

In this section, the following MongoDB Stitch entities are created and configured:

- The MongoDB Stitch Function **testInsertData** that will be used to store *DataSender* data in the MongoDB Collection configured in the previous steps.

### Create MongoDB Stitch Function: testInsertData ###

- In your [MongoDB Atlas account](https://cloud.mongodb.com) select the Stitch Application you created in the previous steps.
- Click **Functions** in the **CONTROL** menu and click **Create New Function**:
![New Function](../png/Sender1.png?raw=true)
- Enter `testInsertData` into the **Function Name** field.
- Click the **Function Editor** tab:
![testInsertData Function](../png/Sender2.png?raw=true)
- Enter the following code into the Function Editor text field:
```
exports = function(data) {
  var collection = context.services.get("mongodb-atlas").db('testdb').collection('data');
  return collection.insertOne({ "data" : data, "received" : false });
};
```
- Click **Save**:
![testInsertData code](../png/Sender3.png?raw=true)

## Additional Setup for DataReceiver ##

This must be performed *before* you run *DataReceiver*. 

In this section, the following MongoDB Stitch entities are created and configured:

- The MongoDB Stitch Function **testFindData** that will be used to receive data from the MongoDB Collection configured in the previous steps.
- The MongoDB Stitch Function **testConfirmData** that will be used to confirm the data has been received.

### Create MongoDB Stitch Function: testFindData ###

- In your [MongoDB Atlas account](https://cloud.mongodb.com) select your Stitch Application, created during the previous steps.
- Click **Functions** in the **CONTROL** menu and click **Create New Function**:
![New Function](../png/Receiver1.png?raw=true)
- Enter `testFindData` into the **Function Name** field.
- Click the **Function Editor** tab:
![testFindData Function](../png/Receiver2.png?raw=true)
- Enter the following code into the Function Editor text field:
```
exports = function() {
  var collection = context.services.get("mongodb-atlas").db('testdb').collection('data');
  return collection.find({ "received" : false }).limit(10).toArray();
};
```
- Click **Save**:
![testFindData code](../png/Receiver3.png?raw=true)

### Create MongoDB Stitch Function: testConfirmData ###

- Click **Functions** in the **CONTROL** menu and click **Create New Function**:
![New Function](../png/Receiver4.png?raw=true)
- Enter `testConfirmData` into the **Function Name** field.
- Click **Function Editor** tab:
![testConfirmData Function](../png/Receiver5.png?raw=true)
- Enter the following code into the Function Editor text field:
```
exports = function(ids) {
  var collection = context.services.get("mongodb-atlas").db('testdb').collection('data');
  return collection.updateMany({ "_id" : { "$in" : ids } }, { "$set" : { "received" : true } });
};
```
- Click **Save**:
![testConfirmData code](../png/Receiver6.png?raw=true)
