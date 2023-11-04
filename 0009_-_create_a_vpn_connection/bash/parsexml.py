import xml.etree.ElementTree as ET
import argparse
import textwrap


def parse_xml(xml_data):
    # Parse the XML data
    root = ET.fromstring(xml_data)

    # Extract the necessary information
    customer_gateway = root.find('.//customer_gateway/tunnel_outside_address/ip_address').text
    vpn_gateway = root.find('.//vpn_gateway/tunnel_outside_address/ip_address').text
    psk = root.find('.//ike/pre_shared_key').text

    return (customer_gateway, vpn_gateway, psk)

def generate_tun1(customer_gateway, vpn_gateway, onprem_cidr, remote_cidr):
    openswan_config = textwrap.dedent(f"""\
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
        """)
    return openswan_config


def generate_secrets(customer_gateway, vpn_gateway, psk):
    return f"{customer_gateway} {vpn_gateway}: PSK \"{psk}\""


# Print the generated Openswan configuration
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate openswan config file from xml")
    parser.add_argument("xml_file", help="XML file containing VPN connection data")
    parser.add_argument("onprem_cidr", help="CIDR of onprem VPC")
    parser.add_argument("remote_cidr", help="CIDR of remote VPC")
    args = parser.parse_args()

    with open(args.xml_file, "r") as file:
        contents = file.read()
        cgw, vgw, psk = parse_xml(contents)
        tun1_config = generate_tun1(cgw, vgw, args.onprem_cidr, args.remote_cidr)
        tun1_secrets = generate_secrets(cgw, vgw, psk)

    # Write the Tunnel1 configuration to 'tun1.conf'
        with open('tun1.conf', 'w') as config_file:
            config_file.write(tun1_config)
        print("Tunnel1 Configuration has been written to 'tun1.conf'")

        # Write the Tunnel1 Secrets configuration to 'tun1.secrets'
        with open('tun1.secrets', 'w') as secrets_file:
            secrets_file.write(tun1_secrets)
        print("Tunnel1 Secrets Configuration has been written to 'tun1.secrets'")
