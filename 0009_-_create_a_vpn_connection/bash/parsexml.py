import xml.etree.ElementTree as ET
import argparse


def parse_xml(xml_data, onprem_cidr, remote_cidr):
    # Parse the XML data
    root = ET.fromstring(xml_data)

    # Extract the necessary information
    customer_gateway = root.find('.//customer_gateway/tunnel_outside_address/ip_address').text
    vpn_gateway = root.find('.//vpn_gateway/tunnel_outside_address/ip_address').text
    openswan_config = f"""\
conn Tunnel1
  authby=secret
  auto=start
  left=%defaultroute
  leftid={customer_gateway}
  right={vpn_gateway}
  type=tunnel
  ikelifetime=8h
  keylife=1h
  phase2alg=aes128-sha1;modp1024
  ike=aes128-sha1;modp1024
  auth=esp
  keyingtries=%forever
  keyexchange=ike
  leftsubnet={onprem_cidr}
  rightsubnet={remote_cidr}
  dpddelay=10
  dpdtimeout=30
  dpdaction=restart_by_peer
"""
    return openswan_config


# Print the generated Openswan configuration
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate openswan config file from xml")
    parser.add_argument("xml_file", help="XML file containing VPN connection data")
    parser.add_argument("onprem_cidr", help="CIDR of onprem VPC")
    parser.add_argument("remote_cidr", help="CIDR of remote VPC")
    args = parser.parse_args()
    with open(args.xml_file, "r") as file:
        contents = file.read()
        print(parse_xml(contents, args.onprem_cidr, args.remote_cidr))

