Tutorial
********

This tutorial will walk you through how to create a
site-to-site VPN connection between two VPCs in
different accounts.

The remote account is assumed to have an existing vpc
named ``vpn_poc_cloud`` with a CIDR of ``10.3.0.0/16``.

The on-prem account is assumed to have an existing vpc
named ``vpc_poc_onprem`` with a CIDR of
``10.4.0.0/16``, and an ec2 instance named
``openswan``.


In the on-prem network
----------------------
* Create an EC2 instance in a public subnet. Allow SSH
  and ICMP through the security group.

  .. image:: ./images/create_openswan_instance.gif

In the remote network
---------------------
* Create a customer gateway. Set the routing to static.
  The ip address should be the public ip of your
  on-prem ``openswan`` instance.

  * Name: AWS-VPC-CGW
  * Routing: static
  * IP: public IP of on-premises EC2

  .. image:: ./images/create_cgw.gif

* Create a virtual private gateway and attach it to the
  ``vpc_poc_cloud`` VPC. Name it AWS-VPC-VGW.

  .. image:: ./images/create_vpg.gif

* Create a VPN connection.

  * Name: ON-PREM-AWS-VPN
  * Target type: Virtual Private Gateway
  * Select the CGW and VGW
  * Routing: static - enter prefix: e.g.
    ``10.4.0.0/16``, ``10.3.0.0/16``.

  .. image:: ./images/create_vpn_conn.gif

* Enable route propagation for all of the VPCs route
  tables.

  .. image:: ./images/enable_route_prop.gif

* Download the VPN connections configuration file in
  openswan format.


In the on-prem network
----------------------
* SSH into the instance.

* Run these commands::

    sudo -i
    yum install openswan -y
    cat << "EOF" > /etc/sysctl.conf
      net.ipv4.ip_forward = 1
      net.ipv4.conf.all.accept_redirects = 0
      net.ipv4.conf.all.send_redirects = 0
    EOF
    sysctl -p

* Using your editor, create the configuration files

  ::

   nano /etc/ipsec.d/aws.conf

  Paste the tunnel configuration that you downloaded from the VPN connection for TUNNEL 1.
  Be sure to substitute in the values for anything between curly braces.

  ::

    conn Tunnel1
      authby=secret
      auto=start
      left=%defaultroute
      leftid={tunnel1_cgw_outside_ip_address}
      right={tunnel1_vgw_outside_ip_address}
      type=tunnel
      ikelifetime=8h
      keylife=1h
      phase2alg=aes128-sha1;modp1024
      ike=aes128-sha1;modp1024
      keyingtries=%forever
      keyexchange=ike
      leftsubnet={onprem_cidr}
      rightsubnet={remote_cidr}
      dpddelay=10
      dpdtimeout=30
      dpdaction=restart_by_peer

  IMPORTANT: REMOVE auth=esp from the code above if present

  ::

    nano /etc/ipsec.d/aws.secrets

  Add single line, for example: ``54.169.159.173 54.66.224.114: PSK
  "Vkm1hzbkdxLHb7wO2TJJnRLTdWH_n6u3"`` The above can be
  found in the downloaded config file - MUST be updated
  with correct values ***

  # Run commands::

    systemctl start ipsec
    systemctl status ipsec

  The connection should now be up. Test by pinging in both
  directions and use additional host in on-premises DC to ping
  EC2 instance in AWS VPC (update route table).

* Add a route to the instance in all of the on-prem route tables.

  .. image:: ./images/add_static_route_to_rtbs.gif
