Worklog
*******

Creating the subnet layout
--------------------------
Here is the subnet layout I came up with. When I started I thought I'd have to implement 6 AZs. https://www.davidc.net/sites/default/subnets/subnets.html?network=10.1.0.0&mask=16&division=39.f46455d231. It's easy to change afterwards, adjust the variables in ``terraform/variable.tf``.

Testing the VPC
---------------
The VPC is implemented using a TF module. I deployed it and launched two instances to test the nat instance. One in public-us-east-1a, and another in priavte-us-east-1a. I can make outbound connections from the back-end instance. Issuing ``yum update -y`` works. Tearing down the instances.

Learning about best practices
-----------------------------
I think that there is a better way to keep track of the IP addresses here than using a subnet calculator. So I read these pages. I don't have time to implement IPAM.

https://aws.amazon.com/blogs/networking-and-content-delivery/amazon-vpc-ip-address-manager-best-practices/

https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html