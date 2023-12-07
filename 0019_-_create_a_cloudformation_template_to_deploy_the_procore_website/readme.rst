***************************************************************************
 Ticket 19. Create a Cloudformation template to deploy the procore website
***************************************************************************
Management wants to improve the deployability of the Procore Website and has
asked that we create a cloudformation template that can be used to deploy the
Procore website anywhere (any VPC, any AWS account)

The cloudformation template should create the following resources:

* An autoscaling Launch Template with the appropriate userdata script and
  instance profile
* Autoscaling group with a desired capacity of 2 and the minimum capacity of 1,
  maximum capacity should be 3.
* Load balancer to handle the traffic to the instances in the autoscaling group
* Provide the URL of the load balancer as output.

Add a screenshot of the result of the finished stack and also a copy of the
code.
