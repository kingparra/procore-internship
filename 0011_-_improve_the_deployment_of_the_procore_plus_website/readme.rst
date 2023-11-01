************************************************************************
 Ticket 11. Improve the deployment of the Procore Plus product website
************************************************************************


Requirements
------------
Improve the deployment of the Procore Plus Product
Website by using code deploy to push changes to
the website.

* Use Code Deploy to make changes to the workloads
* Make 4 rounds of changes to the workload using code deploy

NOTE: In order to do this you are going to have to classify files (images,
scripts, index.html) in their appropriate directories.

Modify the Launch Template
^^^^^^^^^^^^^^^^^^^^^^^^^^
Make the necessary modifications to the launch
template so it can be use with CodeDeploy. Provide
copy of the new userdata script and the policy
attach to the role.

Create a simple pipeline 
^^^^^^^^^^^^^^^^^^^^^^^^
Create a simple pipeline to deploy code to the
autoscaling group using Codedeploy

The pipeline should use codecommit and codedeploy
to deploy the code to the autoscaling group. And
pipeline is triggered when you push a change to
the CodeCommit repository. Download the website
changes from the following bucket:
https://procoreplusproductswebsitechanges.s3.amazonaws.com/procore-products-modifications.zip

Provide screenshot of the success completion of
the pipeline.

Add a maintenance banner
^^^^^^^^^^^^^^^^^^^^^^^^
Add a maintenance banner on the website to notify
all users that the site is under maintenance by
pushing new code to the repo and that should
trigger the pipeline.

Using the code under the directory
websiteDownForMaintenance add a banner to the
website announcing that it will be down for
maintenance. Provide screenshot of the website
with banner.

Modify user account profile picture in website
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
A user requested us to change the profile picture
in his account, for that you need to modify the
code of the website, under notificationPhotoChange
you should find the required code. Provide
screenshot of the website with the new profile
picture.

Update Performance chart on Procore Products Website
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The Procore Products Website needs a new update,
please add a new feature to the performance chart.
Name of the new item: "Cache Memory" Pink Color
Bar

File to be replace: tooplate-scripts.js

Location of the new script:
addPinkBarToPerformanceChart directory

Provide screenshot of the website with the new
chart information displayed.

Uupdate Order List on the Procore Products Website
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
You been ask to removed all cancelled orders from
the order list table on the Procore Products
Website. Use the pipeline to push the new list.
The new update files to use are on the following
directory: removeCancelledProducts.

Provide screenshot of the new order list.

Remove maintenance banner
^^^^^^^^^^^^^^^^^^^^^^^^^
Now that you fix all the issues on the Procore
Plus Product website please remove the maintenance
banner you added. Please use the files under
websiteUpAndReady

Provide url link of the website with all the
changes applied.


Implementation
--------------
The code for this project is an extension of what is in 
the ``../0010*/terraform`` directory, and it uses the
same state file.

You can view the differences with
``diff 0010_-_deploy_a_highly_available_website/terraform/ 0011_-_improve_the_deployment_of_the_procore_plus_website/terraform/``.

All new resources are tagged with a new ``TicketName2`` tag.
