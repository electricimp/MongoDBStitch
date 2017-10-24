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

This example inserts data into preconfigured MongoDB collection using preconfigured MongoDB Stitch named pipeline:

- Data are sent every 10 seconds.
- Every data record contains:
  - `"value"` attribute - integer value, converted to string, which starts at 1 and increases by 1 with every record sent. It restarts from 1 everytime when the example is restarted.
  - `"measureTime"` attribute - integer value, converted to string, which is the time in seconds since the epoch.

![DataSender example](https://imgur.com/fM75b66.png)

## DataReceiver

This example receives new data from preconfigured MongoDB collection and confirms data receiving using preconfigured MongoDB Stitch named pipelines:

- Data are received every 15 seconds.
- Every received data record is printed to the log.
- Data receiving is confirmed by updating the data `"received"` attribute using preconfigured MongoDB Stitch named pipeline.

![DataReceiver example](https://imgur.com/iqYL7Lx.png)

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
    ![Build a new cluster](https://imgur.com/LgH6JXj.png)
  - In the **Build Your New Cluster** pop up
    - Optionally modify **Cluster Name**.
    - Click **Select** for **M0 Instance Size**.
    ![Select M0 Cluster](https://imgur.com/6zFNb7O.png)
    - In the bottom of the pop up enter Admin **Username** and **Password** and click **Confirm & Deploy**.
    ![Deploy Cluster](https://imgur.com/hUSnhwR.png)
    - Wait until your Cluster is deployed (this may take several minutes).
    
##### Create MongoDB Stitch Application

- Click **Stitch Apps** in the **PROJECT** menu and click **Create New Application** button.
![Create new app](https://imgur.com/Sc4XqTn.png)
- In the **Create a new application** pop up
  - Enter **Application Name**, e.g. `testApp`.
  - Choose a **Cluster**.
  - Click **Create**.
    ![Create app](https://imgur.com/HETHghw.png)
  - Wait until your Application is created (this may take several seconds).
- You will be redirected to your Stitch Application page.
- Click **Clients** in the **STITCH CONSOLE** menu.
- Copy (click **COPY APP ID**) and save somewhere **App ID** of your Stitch application. It will be used as the value of *MONGO_DB_STITCH_APPLICATION_ID* constant in the example code for IMP agent.
![Copy app id](https://imgur.com/LP2iNUV.png)

##### Enable API Key Authentication for the Stitch Application

- Click **Authentication** in the **CONTROL** menu.
- Click **Edit** for **API Keys** provider.
  ![Edit Api Keys](https://imgur.com/QXPHxga.png)
- In the **Edit Auth Provider** pop up
  - Set the **API Keys** switch to enabled.
  - Click **CREATE API KEY**.
    ![Create Api Key](https://imgur.com/hzF5l4T.png)
  - Enter a name for the API key into the text input, e.g. `test`.
  - Click **Save**.
    ![Save Api Key](https://imgur.com/auy8qsA.png)
  - Copy (click **COPY**) and save somewhere **API key** of your Stitch application. It will be used as the value of *MONGO_DB_STITCH_API_KEY* constant in the example code for IMP agent.
    ![Copy Api Key](https://imgur.com/5A4Fa7E.png)
  - Close the **Edit Auth Provider** pop up.

##### Create MongoDB Collection

- Click **mongodb-atlas** in the **ATLAS CLUSTERS** menu and click **NEW** for **MongoDB Collections**.
![New Collection](https://imgur.com/TBJtbrl.png)
- Enter `testdb` into **Database** name and `data` into **Collection** name.
- Click **CREATE**.
![Create Collection](https://imgur.com/ruhTVfr.png)
- Click to your newly created collection.
![Created Collection](https://imgur.com/qKadkif.png)
- Click **Top-Level Document**.
![Top-Level Document](https://imgur.com/ArQcZCv.png)
- Modify **READ** permission on top-level document to `{}`.
- Modify **WRITE** permission on top-level document to `{}`.
- Click **SAVE**.
![Top-Level Document Modification](https://imgur.com/n5Z6Wpl.png)
- Click **owner_id** field.
- Click the **delete** (**x**) on the right side.
![Delete owner_id](https://imgur.com/vGEyz3u.png)
- In the **Confirm** pop up click **OK** to confirm **owner_id** field deleting.
- Click **SAVE**.
![Collection Rules](https://imgur.com/N36mOem.png)
- Click the **Filters** tab.
- Click **DELETE** for the existing filter and click **SAVE**.
![Collection Filters](https://imgur.com/zntYVVm.png)

#### IMP Agent Constants Setup

- For *MONGO_DB_STITCH_APPLICATION_ID* and *MONGO_DB_STITCH_API_KEY* constants in the example code for IMP agent: set the values you retrieved and saved in the previous steps. Set the same values for the both examples - **DataSender** and **DataReceiver**.
![Configuration Constants](https://imgur.com/GtK78op.png)

### Additional Setup for DataSender Example

This must be performed **before** you run **DataSender** example code. 

In this section the following MongoDB Stitch entities are created and configured:
- MongoDB Stitch Named Pipeline **testInsertData** that will be used to store DataSender Example data into the MongoDB Collection configured in the previous steps

##### Create MongoDB Stitch Named Pipeline: testInsertData

- In your [MongoDB Atlas account](https://cloud.mongodb.com) select your Stitch Application, created during the previous steps.
- Click **Pipelines** in the **CONTROL** menu and click the **NEW PIPELINE** button.
![New Pipeline](https://imgur.com/E3gvwiz.png)
- Enter `testInsertData` into **New Pipeline Name** field.
- Click **+ ADD PARAMETER**.
- Enter `data` into **Parameter Name** field.
- Set the **Required** switch to enabled.
![testInsertData pipeline config](https://imgur.com/dHajWND.png)
- Click **EDIT** in the pipeline Stage.
![testInsertData edit](https://imgur.com/XmZu7UB.png)
- Set the **Bind data to %%vars** switch to enabled.
- Enter `{"data" : "%%args.data"}` into **Bind data** text field.
![testInsertData vars](https://imgur.com/43MdIVD.png)
- Choose **built-in** in **SERVICE** drop-down list.
- Choose **literal** in **ACTION** drop-down list.
- Enter the following into the pipeline arguments text field
```
{
  "items" : [ {
    "data" : "%%vars.data",
    "received" : false
  } ]
}
```
- Click **Done**.
![testInsertData first stage](https://imgur.com/QrHPd8A.png)
- Click **+ Add Stage**.
![Add Stage](https://imgur.com/Sq2VIFn.png)
- Click **EDIT** in the second Stage.
![Edit second stage](https://imgur.com/SRrOH1U.png)
- Choose **mongodb-atlas** in **SERVICE** drop-down list.
- Choose **insert** in **ACTION** drop-down list.
- Enter the following into the pipeline arguments text field
```
{
  "database": "testdb",
  "collection": "data"
}
```
- Click **Done**.
![testInsertData second stage](https://imgur.com/uCekwSL.png)
- Make sure your **testInsertData** pipeline looks like this: 
![testInsertData pipeline](https://imgur.com/sWu6340.png)
- Click **SAVE**.

### Additional Setup for DataReceiver Example

This must be performed **before** you run **DataReceiver** example code. 

In this section the following MongoDB Stitch entities are created and configured:
- MongoDB Stitch Named Pipeline **testFindData** that will be used to receive data from the MongoDB Collection configured in the previous steps
- MongoDB Stitch Named Pipeline **testConfirmData** that will be used to confirm the data receiving

##### Create MongoDB Stitch Named Pipeline: testFindData

- In your [MongoDB Atlas account](https://cloud.mongodb.com) select your Stitch Application, created during the previous steps.
- Click **Pipelines** in the **CONTROL** menu and click the **NEW PIPELINE** button.
![New Pipeline](https://imgur.com/Pm5ZXwi.png)
- Enter `testFindData` into **New Pipeline Name** field.
- Click **EDIT** in the pipeline Stage.
![testFindData Stage](https://imgur.com/LKuDmYZ.png)
- Choose **mongodb-atlas** in **SERVICE** drop-down list.
- Choose **find** in **ACTION** drop-down list.
- Enter the following into the pipeline arguments text field
```
{
  "database": "testdb",
  "collection": "data",
  "query": { "received" : false },
  "project": {},
  "limit": 10
}
```
- Click **Done**.
![testFindData config](https://imgur.com/M5Yq6hv.png)
- Make sure your **testFindData** pipeline looks like this: 
![testFindData pipeline](https://imgur.com/MJJ64qZ.png)
- Click **SAVE**.

##### Create MongoDB Stitch Named Pipeline: testConfirmData

- Click the **NEW PIPELINE** button.
- Enter `testConfirmData` into **New Pipeline Name** field.
- Click **+ ADD PARAMETER**.
- Enter `ids` into **Parameter Name** field.
- Set the **Required** switch to enabled.
![testConfirmData config](https://imgur.com/QjTrmka.png)
- Click **EDIT** in the pipeline Stage.
![testConfirmData Stage](https://imgur.com/k3RYmrA.png)
- Set the **Bind data to %%vars** switch to enabled.
- Enter `{ "ids" : "%%args.ids" }` into **Bind data** text field.
![testConfirmData vars](https://imgur.com/rWg7RN1.png)
- Choose **mongodb-atlas** in **SERVICE** drop-down list.
- Choose **update** in **ACTION** drop-down list.
- Enter the following into the pipeline arguments text field
```
{
  "database": "testdb",
  "collection": "data",
  "query": {
    "_id": { "$in" : "%%vars.ids" }
  },
  "update": {
    "$set": { "received": true }
  },
  "upsert": false,
  "multi": true
}
```
- Click **Done**.
![testConfirmData Stage config](https://imgur.com/UqxmFoC.png)
- Make sure your **testConfirmData** pipeline looks like this: 
![testConfirmData pipeline](https://imgur.com/zgv7jXv.png)
- Click **SAVE**.
