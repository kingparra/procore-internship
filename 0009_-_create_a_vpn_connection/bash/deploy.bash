#!/usr/bin/env bash
## This script shows the steps to create resources specific to a
## site-to-site vpn. It assumes you have two VPCs: one for on-prem,
## and another for the cloud account. The on-prem VPC has a server
## running openswan on it.
##
## To set this up -- navigate to the terraform directory and run:
## $ terraform apply -target module.onprem_vpc                           │
## $ terraform apply -target module.cloud_vpc
## $ terraform apply -target aws_key_pair.key_object
## $ terraform apply -target aws_instance.openswan
##
## The goal is to create all of the resources needed to get a
## configuration file for the openswan server.
##
## The idea is that you can use this as a reference when writing your own IaC
## using imperative tools (like Pythons Boto3). Unlike terraform, you have to
## attach the vpn gateway explicitly as a separate step.





##########################
#### In the cLoud vpc ####
##########################


###########
### CGW ###
###########
# Get the vpc id of our existing cloud vpc named vpc_poc_cloud
cloud_vpc_vpcid=$(aws ec2 describe-vpcs \
  --query "Vpcs[?Tags[?Key=='Name' && Value=='vpn_poc_cloud']].VpcId" \
  --output text)

# Get the ip address of our on-prem openswan instance
openswan_pubip=$(
  aws --profile personal ec2 describe-instances \
    --query "Reservations[].Instances[?Tags[?Key=='Name' && Value=='openswan']].PublicIpAddress[]" \
    --output text)

# Create the customer gateway (CGW) resource, which represents the actual
# openswan server as a component of the vpn connection.
aws ec2 create-customer-gateway \
  --ip-address "$openswan_pubip" \
  --type ipsec.1 \
  --tag-specifications \
    "ResourceType='customer-gateway',Tags=[{Key='Name',Value='onprem_openswan'}]"


###########
### VPG ###
###########
# Create the virtual private gateway
# The VPG is the VPN concentrator on the amazon side of the site-to-site vpn connection.
# You create a VPG and attach it to a VPC with resources that must access the site-to-site VPN connection.
aws ec2 create-vpn-gateway \
  --type ipsec.1 \
  --tag-specifications "ResourceType='vpn-gateway',Tags=[{Key='Name',Value='onprem_endpoint'}]"

vpg_id=$(aws ec2 describe-vpn-gateways \
  --query "VpnGateways[?Tags[?Key == 'Name' && Value == 'onprem_endpoint']].VpnGatewayId" \
  --output text)

# Attach the VPG to the VPC -- this allows routes to be propagated from the VPN connection to rtbs
aws ec2 attach-vpn-gateway \
  --vpc-id "$cloud_vpc_vpcid" \
  --vpn-gateway-id "$vpg_id"

# Get the route table ids for all rtbs that belong to the cloud_vpc
# shellcheck disable=SC2207
rtbs=($(aws ec2 describe-route-tables \
          --query "RouteTables[?VpcId=='$cloud_vpc_vpcid'].RouteTableId" \
          --output text))

# Turn on route table propagation from the VPG on all of cloud_vpc's route tables
for rtb in "${rtbs[@]}"; do
  aws ec2 enable-vgw-route-propagation \
    --gateway-id "$vpg_id" \
    --route-table-id "$rtb"
done

######################
### VPN Connection ###
######################
# Get the customer gateway id
cgw_id=$(aws ec2 describe-customer-gateways \
  --query "CustomerGateways[?Tags[?Key=='Name' && Value=='onprem_openswan']].CustomerGatewayId" \
  --output text)

# Get the VPG id
vpg_id=$(aws ec2 describe-vpn-gateways \
  --query "VpnGateways[?Tags[?Key == 'Name' && Value == 'onprem_endpoint']].VpnGatewayId" \
  --output text)

# Create the VPN connection -- this is the api object that will generate the configuration
# settings we need to set up openswan on our on-prem server.
aws ec2 create-vpn-connection \
  --customer-gateway-id "$cgw_id" \
  --vpn-gateway-id "$vpg_id" \
  --type ipsec.1 \
  --options \
    '{
        "StaticRoutesOnly": true,
        "LocalIpv4NetworkCidr": "10.4.0.0/16",
        "RemoteIpv4NetworkCidr": "10.3.0.0/16"
     }' \
  --tag-specifications \
  "ResourceType='vpn-connection',Tags=[{Key='Name',Value='onprem_conn'}]"

# Get the vpn connection id
vpn_conn_id=$(aws ec2 describe-vpn-connections \
    --query "VpnConnections[?Tags[?Key=='Name' && Value==' onprem_conn']].VpnConnectionId" \
    --output text)

# Add two static routes to the vpn connection
aws ec2 create-vpn-connection-route \
  --vpn-connection-id "$vpn_conn_id" \
  --destination-cidr-block "10.3.0.0/16"

aws ec2 create-vpn-connection-route \
  --vpn-connection-id "$vpn_conn_id" \
  --destination-cidr -block "10.3.0.0/16"

# At this point, you have to go to the web console to download the configuration 
# from the vpn connection page for openswan.
#
# Or, you can write a program to parse the output of this xml and generate the
# configuration files you need.
#
#  aws ec2 describe-vpn-connections \
#    --query "VpnConnections[?Tags[?Key=='Name' && Value=='onprem_conn']].CustomerGatewayConfiguration" \
#    --output text
#
# After you've configured openswan on your on-prem server, you
# should add a static route to the openswan server for the 10.3.0.0/16
# network. When you on-prem network is a VPC, add that route to all
# of your VPCs route tables.
