import xml.etree.ElementTree as ET
import argparse
import textwrap


def parse_xml(xml_data):
    root = ET.fromstring(xml_data)

    params = {
        'tun1_cgw': root.find('.//ipsec_tunnel[1]/customer_gateway/tunnel_outside_address/ip_address').text,
        'tun1_vgw': root.find('.//ipsec_tunnel[1]/vpn_gateway/tunnel_outside_address/ip_address').text,
        'tun1_psk': root.find('.//ipsec_tunnel[1]/ike/pre_shared_key').text,
        'tun2_cgw': root.find('.//ipsec_tunnel[2]/customer_gateway/tunnel_outside_address/ip_address').text,
        'tun2_vgw': root.find('.//ipsec_tunnel[2]/vpn_gateway/tunnel_outside_address/ip_address').text,
        'tun2_psk': root.find('.//ipsec_tunnel[2]/ike/pre_shared_key').text
    }

    return params


def generate_tunnel_config(cgw, vgw, onprem_cidr, remote_cidr):
    openswan_config = textwrap.dedent(f"""\
        conn Tunnel1
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

# con Tunnel2
#   right=52.6.16.169

def generate_secrets(cgw, vgw, psk):
    return f"{cgw} {vgw}: PSK \"{psk}\""


def main():
    parser = argparse.ArgumentParser(description="Generate openswan config file from xml")
    parser.add_argument("xml_file", help="XML file containing VPN connection data")
    parser.add_argument("onprem_cidr", help="CIDR of onprem VPC")
    parser.add_argument("remote_cidr", help="CIDR of remote VPC")
    args = parser.parse_args()

    with open(args.xml_file, "r") as file:
        params = parse_xml(file.read())

        tun1_config   = generate_tunnel_config(params["tun1_cgw"],
                                               params["tun1_vgw"],
                                               args.onprem_cidr,
                                               args.remote_cidr)

        with open('tun1.conf', 'w') as config_file:
            config_file.write(tun1_config)
            print("Tunnel1 Configuration has been written to 'tun1.conf'")

        tun1_secrets  = generate_secrets(params["tun1_cgw"],
                                         params["tun1_vgw"], 
                                         params["tun1_psk"])

        with open('tun1.secrets', 'w') as secrets_file:
            secrets_file.write(tun1_secrets)
            print("Tunnel1 Secrets Configuration has been written to 'tun1.secrets'")

        tun2_config   = generate_tunnel_config(params["tun2_cgw"],
                                               params["tun2_vgw"],
                                               args.onprem_cidr,
                                               args.remote_cidr)

        with open('tun2.conf', 'w') as secrets_file:
            secrets_file.write(tun2_config)
            print("Tunnel2 Configuration has been written to 'tun2.conf'")

        tun2_secrets  = generate_secrets(params["tun2_cgw"],
                                         params["tun2_vgw"], 
                                         params["tun2_psk"])

        with open('tun2.secrets', 'w') as secrets_file:
            secrets_file.write(tun2_secrets)
            print("Tunnel2 Secrets Configuration has been written to 'tun2.secrets'")


if __name__ == "__main__":
    main()
