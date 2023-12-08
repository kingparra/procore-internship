********************************************************************************************
 Ticket 17. ( Project ) Use Check_Mk to monitor the service limits in the company's account
********************************************************************************************
ProCore Plus has a Check_MK server on prem and we need to expand it’s capabilities to run checks on AWS Accounts. Configure Check_MK so it can monitor the service limits and other basic information in your company account.
Checkmk is software developed in Python and C++ for IT Infrastructure monitoring. It is used for the monitoring of servers, applications, networks, cloud infrastructures (public, private, hybrid), containers, storage, databases and environment sensors.

Sub Task 1. Configure a VPN connection using Pritunl
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Download and install the Pritunl client on your personal computer from this link: Open Source OpenVPN Client
This VPN software will allow you to access our Check MK server on premise.

Provide screenshot of the application after installed.

Sub Task 2. Create a ticket requesting access through the VPN
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 To get access using Pritunl you need a user profile.
Create a Jira ticket requesting the user profile to be used with Pritunl. Assign the ticket to your supervisor (Santiago).

Provide screenshot of the ticket you created.

Sub Task 3. Connect to the Check_MK server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Use the profile provided to connect to our networks and access the Check_Mk server.
Check_Mk URL: http://10.1.30.38/procore/

To access use your personal username and the temp password we provided you to access your account initially.

Sub Task 4. Configure Check_Mk to talk to AWS
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
To have a better handle on all the service limits of your account the company is requesting all admins to configure Check_Mk to keep track of your account.
Use the following instructions from the official Check_MK site to configure it to monitor your AWS account.

Monitoring Amazon Web Services (AWS)

Provide screenshot of the tool monitoring your account.
