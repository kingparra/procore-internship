Ticket 3. Create an admin cross account role
********************************************

Create an Assume Role in your account that grants access to users from account 832997848483. The users should be able to assume a Role called “procore-admin-crossaccount” that gives them Power User Privileges.

Once you create this cross account Role, please provide the cross account URL

Check ``worklog.rst`` for a log of my work.
The ``terraform/`` directory contains IaC for the ticket.
The state file is on an S3 bucket.