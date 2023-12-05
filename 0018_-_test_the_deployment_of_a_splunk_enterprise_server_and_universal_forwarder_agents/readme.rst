*********************************************************************************************
 Ticket 18. Test the deployment of a Splunk Enterprise Server and Universal Forwarder agents
*********************************************************************************************

Requirements
------------
ProCore would like to test a new method to centralize
its log collections from instances and suggested we POC
the deployment of a third party tool called Splunk. The
Splunk environment should have a Splunk Server and
Splunk Universal Forwarder Agents running on our
Bastion servers. This agent should collect  logs that
have security value (/var/log/secure).

Sub Task 1. Deploy Splunk server on AWS
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Staying on the free tier usage deploy a Splunk
Enterprise AMI server.

* T2 micro instance
* Use the Splunk Enterprise AMI from the AWS MarketPlace
* Deploy in the public subnet of the Prod VPC since it
  needs to be accessible from the internet
* Ports 22 should be accessible from the bastion and
  8000, 554, 8089, 9997 and 443 should be open.
* Once EC2 instance is ready, you can login to Splunk
  Web UI by using http://<PublicDNSOfSplunkInstance>:8000.
* Default username is admin and password is SPLUNK-<EC2InstanceID>.
* Enable Splunk Server as a Splunk Receiver.
  https://docs.splunk.com/Documentation/Forwarder/8.2.3/Forwarder/Enableareceiver

Set the following username and password for the receiver

* Admin username: REDACTED
* Password: REDACTED

Provide screenshot of the login console and the dashboard after you
login to the server.

Sub Task 2. Setup A Splunk Forwarder on both of your Bastion Hosts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Use the Universal Splunk Forwarder to send logs from
  your bastion hosts to the splunk server. Download
  the latest version of the Splunk Universal Forward
  installer.
* Use the following instruction to install the
  forwarder on the Bastion

https://docs.splunk.com/Documentation/Forwarder/8.2.3/Forwarder/Installanixuniversalforwarder#Install_the_universal_forwarder_on_Linux

* Use the following documentation to configure the
  forwarder to send logs to the Receiver

  https://docs.splunk.com/Documentation/Forwarder/8.2.3/Forwarder/Configuretheuniversalforwarder

If asked for credentials. Use the credentials used to
configure the receiver.

* Use port 9997 to send logs to the receiver
* Send all the logs in the  /var/log/ directory to the receiver
* Provide screenshots of the result of each step you take.

Sub Task 3. Filter log information
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The Security team is requiring the last 10 lines of the
/var/log/secure file from both bastion hosts Filter the
information coming from the Bastion hosts and take a
screenshots of the result and add them to this ticket.
