# MongoDBStitch Examples

This document describes the example applications provided with the [MongoDBStitch library](../README.md).

The following example applications are provided:
- **DataSender**, it sends data to MongoDB
- **DataReceiver**, it receives data from MongoDB and confirms the receiving

To see data receiving you need to run **DataReceiver** example after or in parallel with **DataSender** example. We recommend that you:
- run **DataSender** on the agent of one IMP device
- run **DataReceiver** on the agent of a second IMP device

Each example is described below. If you wish to try one out, you'll find generic and example-specific [setup instructions](#examples-setup-and-run) further down the page.

## DataSender

This example inserts data into preconfigured MongoDB collection using preconfigured MongoDB Stitch Function:

- Data are sent every 10 seconds.
- Every data record contains:
  - `"value"` attribute - integer value, converted to string, which starts at 1 and increases by 1 with every record sent. It restarts from 1 every time when the example is restarted.
  - `"measureTime"` attribute - integer value, converted to string, which is the time in seconds since the epoch.

![DataSender example](../png/SenderExample.png?raw=true)

## DataReceiver

This example receives new data from preconfigured MongoDB collection and confirms data receiving using preconfigured MongoDB Stitch Functions:

- Data are received every 15 seconds.
- Every received data record is printed to the log.
- Data receiving is confirmed by updating the data `"received"` attribute using preconfigured MongoDB Stitch Function.

![DataReceiver example](../png/ReceiverExample.png?raw=true)

## Examples Setup and Run

- Copy [DataSender source code](./DataSender.agent.nut) and paste it into Electric Imp IDE as IMP agent code of the device where you run **DataSender** example. Note, before running the code you will need to set the configuration constants as described in the [general setup](#setup-for-all-examples) below.
- Copy [DataReceiver source code](./DataReceiver.agent.nut) and paste it into Electric Imp IDE as IMP agent code of the device where you run **DataReceiver** example. Note, before running the code you will need to set the configuration constants as described in the [general setup](#setup-for-all-examples) below.
- Perform the [general setup](#setup-for-all-examples) applicable for the both examples.
- Perform [additional setup for DataSender example](#additional-setup-for-datasender-example).
- Perform [additional setup for DataReceiver example](#additional-setup-for-datareceiver-example).
- Build and Run **DataSender** IMP agent code.
- Check from the logs in Electric Imp IDE that data insertions are successful.
- Build and Run **DataReceiver** IMP agent code.
- Check from the logs in Electric Imp IDE that data receivings are successful.

You may skip the steps related to **DataReceiver** example if you try **DataSender** example only.

### Setup For All Examples

#### MongoDB Stitch Account Configuration

In this section the following MongoDB Stitch entities are created and configured:
- MongoDB Atlas Cluster
- MongoDB Stitch Application
- API Key Authentication for the Stitch Application
- MongoDB Collection that will be used to store the Examples data

##### Create MongoDB Atlas Cluster

- Login at [MongoDB Atlas account](https://cloud.mongodb.com) in your web browser.
- If you have an existing Atlas cluster that you want to work with, skip this step, otherwise 
  - click **Clusters** in the **PROJECT** menu and click the **Build a New Cluster** button.
    ![Build a new cluster](../png/CreateCluster1.png?raw=true)
  - In the **Build Your New Cluster** pop up
    - Optionally modify **Cluster Name**.
    - Click **Select** for **M0 Instance Size**.
    ![Select M0 Cluster](../png/CreateCluster2.png?raw=true)
    - Click **Confirm & Deploy**.
    ![Deploy Cluster](../png/CreateCluster3.png?raw=true)
    - Wait until your Cluster is deployed (this may take several minutes).
    
##### Create MongoDB Stitch Application

- Click **Stitch Apps** in the **PROJECT** menu and click **Create New Application** button.
![Create new app](../png/CreateApp1.png?raw=true)
- In the **Create a new application** pop up
  - Enter **Application Name**, e.g. `testApp`.
  - Choose a **Cluster**.
  - Click **Create**.
    ![Create app](../png/CreateApp2.png?raw=true)
  - Wait until your Application is created (this may take several seconds).
- You will be redirected to your Stitch Application page.
- Click **Clients** in the application menu.
- Copy (click **COPY**) and save somewhere **App ID** of your Stitch application. It will be used as the value of *MONGO_DB_STITCH_APPLICATION_ID* constant in the example code for IMP agent.
![Copy app id](../png/CreateApp3.png?raw=true)

##### Enable API Key Authentication for the Stitch Application

- Click **Authentication** in the **CONTROL** menu.
- Click **Edit** for **API Keys** provider.
  ![Edit Api Keys](../png/CreateApiKey1.png?raw=true)
- In the **Edit Auth Provider** pop up
  - Set the **API Keys** switch to enabled.
  - Click **CREATE API KEY**.
    ![Create Api Key](../png/CreateApiKey2.png?raw=true)
  - Enter a name for the API key into the text input, e.g. `test`.
  - Click **Save**.
    ![Save Api Key](../png/CreateApiKey3.png?raw=true)
  - Copy (click **COPY**) and save somewhere **API key** of your Stitch application. It will be used as the value of *MONGO_DB_STITCH_API_KEY* constant in the example code for IMP agent.
    ![Copy Api Key](../png/CreateApiKey4.png?raw=true)
  - Close the **Edit Auth Provider** pop up.

##### Create MongoDB Collection

- Click **mongodb-atlas** in the **ATLAS CLUSTERS** menu and click **NEW** for **MongoDB Collections**.
![New Collection](../png/CreateCollection1.png?raw=true)
- Enter `testdb` into **Database** name and `data` into **Collection** name.
- Click **CREATE**.
![Create Collection](../png/CreateCollection2.png?raw=true)
- Click to your newly created collection.
![Created Collection](../png/CreateCollection3.png?raw=true)
- Click **Top-Level Document**.
![Top-Level Document](../png/CreateCollection4.png?raw=true)
- Modify **READ** permission on top-level document to `{}`.
- Modify **WRITE** permission on top-level document to `{}`.
- Click **SAVE**.
![Top-Level Document Modification](../png/CreateCollection5.png?raw=true)
- Click **owner_id** field.
- Click the **delete** (**x**) on the right side.
![Delete owner_id](../png/CreateCollection6.png?raw=true)
- In the confirmation pop up click **Delete Field** to confirm **owner_id** field deleting.
- Click **SAVE**.
![Collection Rules](../png/CreateCollection7.png?raw=true)
- Click the **Filters** tab.
- Click **DELETE** for the existing filter and click **SAVE**.
![Collection Filters](../png/CreateCollection8.png?raw=true)

#### IMP Agent Constants Setup

- For *MONGO_DB_STITCH_APPLICATION_ID* and *MONGO_DB_STITCH_API_KEY* constants in the example code for IMP agent: set the values you retrieved and saved in the previous steps. Set the same values for the both examples - **DataSender** and **DataReceiver**.
![Configuration Constants](../png/ConstSetup.png?raw=true)

### Additional Setup for DataSender Example

This must be performed **before** you run **DataSender** example code. 

In this section the following MongoDB Stitch entities are created and configured:
- MongoDB Stitch Function **testInsertData** that will be used to store DataSender Example data into the MongoDB Collection configured in the previous steps

##### Create MongoDB Stitch Function: testInsertData

- In your [MongoDB Atlas account](https://cloud.mongodb.com) select your Stitch Application, created during the previous steps.
- Click **Functions** in the **CONTROL** menu and click the **Create New Function** button.
![New Function](../png/Sender1.png?raw=true)
- Enter `testInsertData` into **Function Name** field.
- Click **Function Editor** tab.
![testInsertData Function](../png/Sender2.png?raw=true)
- Enter the following code into the Function Editor text field
```
exports = function(data) {
  var collection = context.services.get("mongodb-atlas").db('testdb').collection('data');
  return collection.insertOne({ "data" : data, "received" : false });
};
```
- Click **Save**.
![testInsertData code](../png/Sender3.png?raw=true)

### Additional Setup for DataReceiver Example

This must be performed **before** you run **DataReceiver** example code. 

In this section the following MongoDB Stitch entities are created and configured:
- MongoDB Stitch Function **testFindData** that will be used to receive data from the MongoDB Collection configured in the previous steps
- MongoDB Stitch Function **testConfirmData** that will be used to confirm the data receiving

##### Create MongoDB Stitch Function: testFindData

- In your [MongoDB Atlas account](https://cloud.mongodb.com) select your Stitch Application, created during the previous steps.
- Click **Functions** in the **CONTROL** menu and click the **Create New Function** button.
![New Function](../png/Receiver1.png?raw=true)
- Enter `testFindData` into **Function Name** field.
- Click **Function Editor** tab.
![testFindData Function](../png/Receiver2.png?raw=true)
- Enter the following code into the Function Editor text field
```
exports = function() {
  var collection = context.services.get("mongodb-atlas").db('testdb').collection('data');
  return collection.find({ "received" : false }).limit(10).toArray();
};
```
- Click **Save**.
![testFindData code](../png/Receiver3.png?raw=true)

##### Create MongoDB Stitch Function: testConfirmData

- Click **Functions** in the **CONTROL** menu and click the **Create New Function** button.
![New Function](../png/Receiver4.png?raw=true)
- Enter `testConfirmData` into **Function Name** field.
- Click **Function Editor** tab.
![testConfirmData Function](../png/Receiver5.png?raw=true)
- Enter the following code into the Function Editor text field
```
exports = function(ids) {
  var collection = context.services.get("mongodb-atlas").db('testdb').collection('data');
  return collection.updateMany({ "_id" : { "$in" : ids } }, { "$set" : { "received" : true } });
};
```
- Click **Save**.
![testConfirmData code](../png/Receiver6.png?raw=true)
