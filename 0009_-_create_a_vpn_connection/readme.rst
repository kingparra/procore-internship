***********************************
 Ticket 9. Create a VPN connection
***********************************

Requirements
------------
Procore Plus has a customer that is asking for a site-to-site vpn solution from
one vpc in one account to another vpc in a different account and we need to POC it and
document it to share with the customer.

* Create a vpn site-to-site connection between your own account and the
  organization account using Openswan as the customer gateway.
 
* Provide proof of a successful connection by pinging the instance in your
  organization account from your instance in your personal account.

* Write documentation that captures the process of configuring both sides of the connection.

Implementation
--------------
.. image:: ./images/0009_diagram.drawio.png

There is some example code to set up this architecture.
Install ``bash``, ``openssh``, ``terraform``, and ``python3``.
Then execute the ``./main`` script to run the automation.

You can find documentation on how to set this up in the
``tutorial`` directory. There are instructions on manual
setup through the web console, and some notes about different
approaches for automation.