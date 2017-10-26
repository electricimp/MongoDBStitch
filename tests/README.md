# Test Instructions

The tests in the current directory are intended to check the behavior of the MongoDBStitch library. The current set of tests check:
- login to Stitch using API key
- execution of Stitch Named Pipelines which cover all standard mongodb-atlas services: insert, update, find and delete
- processing of wrong parameters passed into the library methods

The tests are written for and should be used with [impTest](https://github.com/electricimp/impTest). See *impTest* documentation for the details of how to configure and run the tests.

The tests for MongoDBStitch library require pre-setup described below.

## MongoDB Stitch Account Configuration

### Create MongoDB Atlas Cluster

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
    
### Create MongoDB Stitch Application

- If you have an existing Stitch Application that you want to work with, skip this step, otherwise 
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
  - Copy (click **COPY APP ID**) and save somewhere **App ID** of your Stitch application. It will be used as the value of *MONGO_DB_STITCH_APPLICATION_ID* environment variable.
  ![Copy app id](https://imgur.com/LP2iNUV.png)

### Enable API Key Authentication for the Stitch Application

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
  - Copy (click **COPY**) and save somewhere **API key** of your Stitch application. It will be used as the value of *MONGO_DB_STITCH_API_KEY* environment variable.
    ![Copy Api Key](https://imgur.com/5A4Fa7E.png)
  - Close the **Edit Auth Provider** pop up.

### Create MongoDB Collection

- Click **mongodb-atlas** in the **ATLAS CLUSTERS** menu and click **NEW** for **MongoDB Collections**.
![New Collection](https://imgur.com/TBJtbrl.png)
- Enter `imptest` into **Database** name and `data` into **Collection** name.
- Click **CREATE**.
- Click to your newly created collection.
- Click **Top-Level Document**.
- Modify **READ** permission on top-level document to `{}`.
- Modify **WRITE** permission on top-level document to `{}`.
- Click **SAVE**.
![Top-Level Document Modification](https://imgur.com/XtvIJus.png)
- Click **owner_id** field.
- Click the **delete** (**x**) on the right side.
![Delete owner_id](https://imgur.com/XMHKS7r.png)
- In the **Confirm** pop up click **OK** to confirm **owner_id** field deleting.
- Click **SAVE**.
- Click the **Filters** tab.
- Click **DELETE** for the existing filter and click **SAVE**.
![Collection Filters](https://imgur.com/VSgGMpy.png)

### Create MongoDB Stitch Named Pipelines

#### imptestDeleteData Pipeline

- Click **Pipelines** in the **CONTROL** menu and click the **NEW PIPELINE** button.
![New Pipeline](https://imgur.com/E3gvwiz.png)
- Enter `imptestDeleteData` into **New Pipeline Name** field.
- Click **EDIT** in the pipeline Stage.
![imptestDeleteData edit](https://imgur.com/ZkK7osS.png)
- Choose **mongodb-atlas** in **SERVICE** drop-down list.
- Choose **delete** in **ACTION** drop-down list.
- Enter the following into the pipeline arguments text field
```
{
  "database": "imptest",
  "collection": "data",
  "singleDoc": false,
  "query": {}
}
```
- Click **Done**.
- Click **SAVE**.
![imptestDeleteData pipeline](https://imgur.com/b2xepk6.png)

#### imptestDeleteOne Pipeline

- Click the **NEW PIPELINE** button.
- Enter `imptestDeleteOne` into **New Pipeline Name** field.
- Click **+ ADD PARAMETER**.
- Enter `id` into **Parameter Name** field.
- Set the **Required** switch to enabled.
- Click **EDIT** in the pipeline Stage.
- Set the **Bind data to %%vars** switch to enabled.
- Enter `{ "id": "%%args.id" }` into **Bind data** text field.
- Choose **mongodb-atlas** in **SERVICE** drop-down list.
- Choose **delete** in **ACTION** drop-down list.
- Enter the following into the pipeline arguments text field
```
{
  "database": "imptest",
  "collection": "data",
  "singleDoc": true,
  "query": {
    "id": "%%vars.id"
  }
}
```
- Click **Done**.
- Click **SAVE**.
![imptestDeleteOne pipeline](https://imgur.com/je0ZTny.png)

#### imptestFindData Pipeline

- Click the **NEW PIPELINE** button.
- Enter `imptestFindData` into **New Pipeline Name** field.
- Click **+ ADD PARAMETER**.
- Enter `id` into **Parameter Name** field.
- Set the **Required** switch to enabled.
- Click **EDIT** in the pipeline Stage.
- Set the **Bind data to %%vars** switch to enabled.
- Enter `{ "id": "%%args.id" }` into **Bind data** text field.
- Choose **mongodb-atlas** in **SERVICE** drop-down list.
- Choose **find** in **ACTION** drop-down list.
- Enter the following into the pipeline arguments text field
```
{
  "database": "imptest",
  "collection": "data",
  "query": {
    "id": "%%vars.id"
  },
  "project": {},
  "limit": 10
}
```
- Click **Done**.
- Click **SAVE**.
![imptestFindData pipeline](https://imgur.com/mcQGWwm.png)

#### imptestInsertData Pipeline

- Click the **NEW PIPELINE** button.
- Enter `imptestInsertData` into **New Pipeline Name** field.
- Click **+ ADD PARAMETER**.
- Enter `id` into **Parameter Name** field.
- Set the **Required** switch to enabled.
- Click **+ ADD PARAMETER**.
- Enter `value` into **Parameter Name** field.
- Set the **Required** switch to enabled.
- Click **EDIT** in the pipeline Stage.
- Set the **Bind data to %%vars** switch to enabled.
- Enter the following into **Bind data** text field:
```
{
  "id": "%%args.id",
  "value": "%%args.value"
}
```
- Choose **built-in** in **SERVICE** drop-down list.
- Choose **literal** in **ACTION** drop-down list.
- Enter the following into the pipeline arguments text field
```
{
  "items": [
    {
      "id": "%%vars.id",
      "value": "%%vars.value"
    }
  ]
}
```
- Click **Done**.
- Click **+ Add Stage**.
![imptestInsertData first stage](https://imgur.com/MWgW9HT.png)
- Click **EDIT** in the second Stage.
- Choose **mongodb-atlas** in **SERVICE** drop-down list.
- Choose **insert** in **ACTION** drop-down list.
- Enter the following into the pipeline arguments text field
```
{
  "database": "imptest",
  "collection": "data"
}
```
- Click **Done**.
![imptestInsertData second stage](https://imgur.com/XclYiC5.png)
- Click **SAVE**.

#### imptestUpdateData Pipeline

- Click the **NEW PIPELINE** button.
- Enter `imptestUpdateData` into **New Pipeline Name** field.
- Click **+ ADD PARAMETER**.
- Enter `id` into **Parameter Name** field.
- Set the **Required** switch to enabled.
- Click **+ ADD PARAMETER**.
- Enter `value` into **Parameter Name** field.
- Set the **Required** switch to enabled.
- Click **EDIT** in the pipeline Stage.
- Set the **Bind data to %%vars** switch to enabled.
- Enter the following into **Bind data** text field:
```
{
  "id": "%%args.id",
  "value": "%%args.value"
}
```
- Choose **mongodb-atlas** in **SERVICE** drop-down list.
- Choose **update** in **ACTION** drop-down list.
- Enter the following into the pipeline arguments text field
```
{
  "database": "imptest",
  "collection": "data",
  "query": {
    "id": "%%vars.id"
  },
  "update": {
    "$set": {
      "value": "%%vars.value"
    }
  },
  "upsert": false,
  "multi": false
}
```
- Click **Done**.
- Click **SAVE**.
![imptestUpdateData second stage](https://imgur.com/EGXv7Il.png)

## Environment Variables

Set *MONGO_DB_STITCH_APPLICATION_ID* and *MONGO_DB_STITCH_API_KEY* environment variables to the values you retrieved and saved in the previous steps.

