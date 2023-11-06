#!/usr/bin/env python3
import xml.etree.ElementTree as ET
import argparse
import textwrap
from os.path import sep

def parse_xml(xml_data):
    root = ET.fromstring(xml_data)
    params = {
        'tun1_name': 'Tunnel1',
        'tun1_cgw': root.find('.//ipsec_tunnel[1]/customer_gateway/tunnel_outside_address/ip_address').text,
        'tun1_vgw': root.find('.//ipsec_tunnel[1]/vpn_gateway/tunnel_outside_address/ip_address').text,
        'tun1_psk': root.find('.//ipsec_tunnel[1]/ike/pre_shared_key').text,
        'tun2_name': 'Tunnel2',
        'tun2_cgw': root.find('.//ipsec_tunnel[2]/customer_gateway/tunnel_outside_address/ip_address').text,
        'tun2_vgw': root.find('.//ipsec_tunnel[2]/vpn_gateway/tunnel_outside_address/ip_address').text,
        'tun2_psk': root.find('.//ipsec_tunnel[2]/ike/pre_shared_key').text
    }
    return params


def generate_config(name, cgw, vgw, onprem_cidr, remote_cidr):
    openswan_config = textwrap.dedent(f"""\
        conn {name}
          authby=secret
          auto=start
          left=%defaultroute
          leftid={cgw}
          right={vgw}
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
        """)
    return openswan_config


def generate_secrets(cgw, vgw, psk):
    return f"{cgw} {vgw}: PSK \"{psk}\""


def main():
    parser = argparse.ArgumentParser(
        prog='parsexml',
        description="Generate openswan config file from xml"
        )
    parser.add_argument("-f", "--file", dest="xml_file", help="XML file containing VPN connection data")
    parser.add_argument("--onprem-cidr", dest="onprem_cidr", help="CIDR of onprem VPC")
    parser.add_argument("--remote-cidr", dest="remote_cidr", help="CIDR of remote VPC")
    parser.add_argument("-o", "--output-dir", dest="output_dir", help="Directory to save config files to.")
    args = parser.parse_args()

    with open(args.xml_file, "r") as file:
        params = parse_xml(file.read())

        for tunnel in ["tun1", "tun2"]:

            with open(f'{args.output_dir}{sep}{tunnel}.conf', 'w') as config_file:
                config_file.write(generate_config(params[f"{tunnel}_name"],
                                                  params[f"{tunnel}_cgw"],
                                                  params[f"{tunnel}_vgw"],
                                                  args.onprem_cidr,
                                                  args.remote_cidr))
                print(f"{tunnel} Configuration has been written to '{tunnel}.conf'")

            with open(f'{args.output_dir}{sep}{tunnel}.secrets', 'w') as secrets_file:
                secrets_file.write(generate_secrets(params[f"{tunnel}_cgw"],
                                                    params[f"{tunnel}_vgw"],
                                                    params[f"{tunnel}_psk"]))
                print(f"{tunnel} Secrets Configuration has been written to '{tunnel}.secrets'")


if __name__ == "__main__":
    main()
