***************
 State Machine
***************
Use this template to generate a s3 bucket backend.

First, edit the ``ticket_names`` variable in
``variables.tf`` to include your new ticket name
in the list.

Then run ``terraform apply`` to generate a new
backend file.

Finally inspect the generated ``${name}_backend.tf``, 
delete the ``role_arn`` line, copy the new
file to your project directory, and ``cd`` into
it.

To migrate your state to the new backend, run
``terraform init -force-copy`` from your project
directory.
