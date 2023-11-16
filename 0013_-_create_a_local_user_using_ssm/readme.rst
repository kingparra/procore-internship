******************************************
 Ticket 13. Create a local user using SSM
******************************************


Requirements
------------
Procore Plus needs to have a local user
(Username: ``break-glass``) on all the
instances currently deployed in your account.

**Create an SSM document** to deploy this
user so that it can be used again in the
future. In your SSM document include some
commands that verify that the user has been
added.

Since the user will not be able to login with
a password you will need to **add the
following public key** to the authorized key
file. 

``<public_key_ommited>``

Here is `a link <https://aws.amazon.com/premiumsupport/
knowledge-center/new-user-accounts-linux-instance/>`_
with information on how to accomplish this.

Remember to include your SSM document name as
part of the documentation for this ticket in
case someone else needs to run it.

