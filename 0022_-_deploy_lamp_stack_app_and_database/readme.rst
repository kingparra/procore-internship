***********************************************
 Ticket 22. Deploy LAMP Stack app and database
***********************************************
Assist the development team with CRM app deployment
and configuring the database for this application.

* Create a EC2 instances for the application, configure
  it to only be on from noon to 4pm (lambda).

Sub Task 1. Download the zip file from the git repo CRM project
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
the developers added the application to a gitlab repo:
https://gitlab.com/procoreplusmd/crm-project.git This
is the code for the application.

Sub Task 2. Extract the files in your and copy crm folder to the root directory (for lamp var/www/html)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
You will need to unzip the Small_CRM_Projects.zip file
and move the content to the apache path. Use your linux
skills to copy this code to the apache path on your
server.

Sub Task 3. Create a RDS (MySql) database with name crm
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Deploy a MySQL database on RDS service. The name of
the database should be: crm

Provide screenshots of the database created.

Sub Task 4. Import crm.sql file using mysql workbench (given inside the zip package in SQL file folder)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
For this task you will need to install MySql Workbench
on your computer, after you will use this app to
import the crm.sql table to the database you created
in RDS

Provide screenshot of the table in the Workbench.

Sub Task 5. Edit the following files and add the password you used for the MySQL database.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Establish a connection between the application and the
database. To connect the application and the database
you need to edit the files:

::

  vi /var/www/html/crm/dbconnection.php
  vi /var/www/html/crm/admin/dbconnection.php

Ex

::

  <?php
  $con=mysqli_connect("localhost", "root", "Password", "crm");
  if (mysqli_connect_errno()) {
    echo "Connection Fail".mysqli_connect_error();
  }
  ?>


Replace localhost with the RDS endpoint

Replace root with the username of the database

Replace Password with the password used to create the
database

Sub Task 6. Run the script http://public-ip/crm/admin
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Access the application though the admin portal and create a regular user to handle daily task
Run the script http://public-ip/crm/admin

Credential for admin panel:

* Username: admin
* Password: admin

Create a regular user.

Sub Task 7. Run the script (frontend) and create your own regular user by clicking the Sign Up link.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Now you will need to create a user to do all the
frontend task.. using the sign up link. Use this link
to create a regular user: http://public-ip/crm

Sub Task 8. Then test that your user can access the app.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Now lets test that everything is running by accessing
the app with the user you created. Credential for user
panel:

* Username: (use the email as the username)
* Password: (password you assign the user)

If everything is working then you can submit the ticket for review.

