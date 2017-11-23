# Test Instructions

The tests in the current directory are intended to check the behavior of the MongoDBStitch library. The current set of tests check:
- login to Stitch using API key
- execution of Stitch Functions which cover all standard mongodb-atlas services: insert, update, find and delete
- processing of wrong parameters passed into the library methods

The tests are written for and should be used with [impTest](https://github.com/electricimp/impTest). See *impTest* documentation for the details of how to configure and run the tests.

The tests for MongoDBStitch library require pre-setup described below.

## MongoDB Stitch Account Configuration

### Create MongoDB Atlas Cluster

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

### Create MongoDB Stitch Application

- If you have an existing Stitch Application that you want to work with, skip this step, otherwise 
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
  - Copy (click **COPY**) and save somewhere **App ID** of your Stitch application. It will be used as the value of *MONGO_DB_STITCH_APPLICATION_ID* environment variable.
  ![Copy app id](../png/CreateApp3.png?raw=true)

### Enable API Key Authentication for the Stitch Application

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
  - Copy (click **COPY**) and save somewhere **API key** of your Stitch application. It will be used as the value of *MONGO_DB_STITCH_API_KEY* environment variable.
    ![Copy Api Key](../png/CreateApiKey4.png?raw=true)
  - Close the **Edit Auth Provider** pop up.

### Create MongoDB Collection

- Click **mongodb-atlas** in the **ATLAS CLUSTERS** menu and click **NEW** for **MongoDB Collections**.
![New Collection](../png/CreateCollection1.png?raw=true)
- Enter `imptest` into **Database** name and `data` into **Collection** name.
- Click **CREATE**.
- Click to your newly created collection.
- Click **Top-Level Document**.
- Modify **READ** permission on top-level document to `{}`.
- Modify **WRITE** permission on top-level document to `{}`.
- Click **SAVE**.
![Top-Level Document Modification](../png/CreateTestCollection1.png?raw=true)
- Click **owner_id** field.
- Click the **delete** (**x**) on the right side.
![Delete owner_id](../png/CreateTestCollection2.png?raw=true)
- In the confirmation pop up click **Delete Field** to confirm **owner_id** field deleting.
- Click **SAVE**.
- Click the **Filters** tab.
- Click **DELETE** for the existing filter and click **SAVE**.
![Collection Filters](../png/CreateTestCollection3.png?raw=true)

### Create MongoDB Stitch Functions

#### imptestDeleteData Function

- Click **Functions** in the **CONTROL** menu and click the **Create New Function** button.
- Enter `imptestDeleteData` into **Function Name** field.
- Click **Function Editor** tab.
- Enter the following code into the Function Editor text field
```
exports = function() {
  var collection = context.services.get("mongodb-atlas").db('imptest').collection('data');
  return collection.deleteMany();
};
```
- Click **Save**.

#### imptestDeleteOne Function

- Click **Functions** in the **CONTROL** menu and click the **Create New Function** button.
- Enter `imptestDeleteOne` into **Function Name** field.
- Click **Function Editor** tab.
- Enter the following code into the Function Editor text field
```
exports = function(id) {
  var collection = context.services.get("mongodb-atlas").db('imptest').collection('data');
  return collection.deleteOne({ "id" : id });
};
```
- Click **Save**.

#### imptestFindData Function

- Click **Functions** in the **CONTROL** menu and click the **Create New Function** button.
- Enter `imptestFindData` into **Function Name** field.
- Click **Function Editor** tab.
- Enter the following code into the Function Editor text field
```
exports = function(id) {
  var collection = context.services.get("mongodb-atlas").db('imptest').collection('data');
  return collection.find({ "id" : id }).toArray();
};
```
- Click **Save**.

#### imptestInsertData Function

- Click **Functions** in the **CONTROL** menu and click the **Create New Function** button.
- Enter `imptestInsertData` into **Function Name** field.
- Click **Function Editor** tab.
- Enter the following code into the Function Editor text field
```
exports = function(id, value) {
  var collection = context.services.get("mongodb-atlas").db('imptest').collection('data');
  return collection.insertOne({ "id" : id, "value" : value });
};
```
- Click **Save**.

#### imptestUpdateData Function

- Click **Functions** in the **CONTROL** menu and click the **Create New Function** button.
- Enter `imptestUpdateData` into **Function Name** field.
- Click **Function Editor** tab.
- Enter the following code into the Function Editor text field
```
exports = function(id, newValue) {
  var collection = context.services.get("mongodb-atlas").db('imptest').collection('data');
  return collection.updateOne({ "id" : id }, { "$set": { "value" : newValue }});
};
```
- Click **Save**.

## Environment Variables

Set *MONGO_DB_STITCH_APPLICATION_ID* and *MONGO_DB_STITCH_API_KEY* environment variables to the values you retrieved and saved in the previous steps.
