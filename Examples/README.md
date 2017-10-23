# MongoDBStitch Examples

This document describes the sample applications provided with the [MongoDBStitch library](../README.md).

The following example applications are provided:
- DataSender
- DataReceiver

We recommend that you:
- run DataSender on the agent of one device
- run DataReceiver on the agent of a second device

To see data receiving you need to run the DataReceiver example alongside the DataSender example.

Each example is described below. If you wish to try one out, you'll find generic and example-specific setup instructions further down the page.

## DataSender

This example inserts data to preconfigured MongoDB collection using preconfigured MongoDB Stitch named pipeline.

### Notes

- Data are sent every ten seconds.
- Every data record contains:
  - integer value, converted to string, which starts at 1 and increases by 1 with every record sent. It restarts from 1 when the example is restarted.
  - `"measureTime"` attribute, which is the time in seconds since the epoch.

![DataSender example](https://imgur.com/fM75b66.png)

## DataReceiver

This example receives new data from preconfigured MongoDB collection and confirms data receiving using preconfigured MongoDB Stitch named pipelines.

### Notes

- Data are received every fifteen seconds.
- Every data record received is printed to the log.
- Data receiving is confirmed by updating data `"received"` attribute using preconfigured MongoDB Stitch named pipeline.

![DataReceiver example](https://imgur.com/iqYL7Lx.png)

## Examples Setup

Copy and paste the code linked below for the example you wish to run.  

- [DataSender](./DataSender.agent.nut)
- [DataReceiver](./DataReceiver.agent.nut)

Before running an example application you need to set the configuration constants in the application (agent) source code. The instructions below will walk you through the necessary steps.

After the general setup you need to perform additional example-specific setup

- [Additional setup for the DataSender example](#additional-setup-for-the-datasender-example)
- [Additional setup for the DataReceiver example](#additional-setup-for-the-datareceiver-example)

### Setup For All Examples

#### MongoDB Stitch Account Configuration

In this section the following MongoDB Stitch entities are created and configured:
- MongoDB Atlas cluster
- MongoDB Stitch Application
- API Key Authentication for the Stitch Application
- MongoDB Collection that will be used to store the Examples data

##### Configuration Steps

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
    - Wait until your Cluster is created.
- Click **Stitch Apps** in the **PROJECT** menu and click **Create New Application** button.
![Create new app](https://imgur.com/Sc4XqTn.png)
- In the **Create a new application** pop up
  - Enter **Application Name**, e.g. `testApp`.
  - Click **Create**.
    ![Create app](https://imgur.com/HETHghw.png)
- You will be redirected to your Stitch Application page.
- Click **Clients** in the **STITCH CONSOLE** menu.
Copy your Application ID, it will be used as the *MONGO_DB_STITCH_APPLICATION_ID* Examples constant.
![Copy app id](https://imgur.com/LP2iNUV.png)
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
  - Click **COPY** for your API key, it will be used as the *MONGO_DB_STITCH_API_KEY* Examples constant.
    ![Copy Api Key](https://imgur.com/5A4Fa7E.png)
  - Close the **Edit Auth Provider** pop up.
- Click **mongodb-atlas** in the **ATLAS CLUSTERS** menu and click **NEW** for **MongoDB Collections**.
![New Collection](https://imgur.com/TBJtbrl.png)
- Enter `testdb` into **Database** name and `data` into **Collection** name.
![Create Collection](https://imgur.com/ruhTVfr.png)
- Click **CREATE**.
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

#### Constants Setup

Set the example code configuration constants *MONGO_DB_STITCH_APPLICATION_ID* and *MONGO_DB_STITCH_API_KEY* with the values retrieved in the previous steps. You can use the same configuration constants when running examples in parallel.
![Configuration Constants](https://imgur.com/GtK78op.png)

### Additional Setup for the DataSender Example

This must be performed **before** you run the DataSender example code. 

In this section the following MongoDB Stitch entities are created and configured:
- MongoDB Stitch Named Pipeline **testInsertData** that will be used to store DataSender Example data into the MongoDB Collection configured in the previous steps

##### Configuration Steps

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
- Choose **built-in** in **SERVICE** drop-down list if it has different value.
- Choose **literal** in **ACTION** drop-down list if it has different value.
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

### Additional Setup for the DataReceiver Example

This must be performed **before** you run the DataReceiver example code. 

In this section the following MongoDB Stitch entities are created and configured:
- MongoDB Stitch Named Pipeline **testFindData** that will be used to receive data from the MongoDB Collection configured in the previous steps
- MongoDB Stitch Named Pipeline **testConfirmData** that will be used to confirm data receiving

##### Configuration Steps

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
