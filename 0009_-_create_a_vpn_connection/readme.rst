***********************************
 Ticket 9. Create a VPN connection
***********************************

Requirements
------------
Procore Plus has a customer that is asking for a site-to-site vpn solution from
one vpc in one account to another vpc in a different account (to workaround a
technical difficulty at the application level) and we need to POC it and
document it to share with the customer.

* Create a vpn site-to-site connection between your own account and the
  organization account using Openswan as the customer gateway.
  One of our engineers found a `video: Setup an AWS Site-to-Site VPN
  <https://www.youtube.com/watch?v=7tTrN8WXMlg>`_
  that should explain how most of this is accomplished.

* Provide proof of a successful connection by pinging the instance in your
  organization account from your instance in your personal account.

* Openswan must be deployed in your personal account as a ``t2.micro``.

* The VITI connection should be initiated from the Procore account.

* Write documentation that captures the process of configuring both sides of
  the connection.

Deploy the Openswan Instance as Customer Gateway
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
In your personal account deploy Openswan as a customer gateway. Openswan is an
implementation of IPsec for Linux and a continuation of the FreeS/WAN project
(dating back to 1999). Openswan enables the set-up of IPsec links between
machines, as well as VPN tunnels, both between corporate networks and for
mobile clients. It is compatible with a large number of operating systems and
proprietary solutions.

Configure the AWS site to site VPN
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Go through the process of creating a VPN connection from the company's account
to your personal account.

Test your VPN connection
^^^^^^^^^^^^^^^^^^^^^^^^
If you followed the instructions on the video provided you should have created
an instance in both of your accounts, to test if the vpn tunnel is working you
should be able to ping the instance in your personal account from the instance
in the company's account.

Provide a screenshot of the ping result.

Write documentation
^^^^^^^^^^^^^^^^^^^
Since this solution will be shared with the customer you need to create a
detail guide of how to accomplished this VPN connection.

..
  Implementation
  --------------
