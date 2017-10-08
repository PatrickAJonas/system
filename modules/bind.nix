{ config, lib, pkgs, fetchFromGitHub, ... }:

with lib;

let
  domain = config.domain;
  ip = config.networking.interfaces.eth0.ipAddress;
  ip6 = config.networking.interfaces.eth0.ipv6Address;
  subdomains = [
    "www"
    "dav"
    "keys"
    "test"
    "mail"
    "mac"
  ];
in
{
  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  services = {
    fail2ban = {
      enable = true;
    };

    bind = {
      enable = true;
      cacheNetworks = [
        "127.0.0.0/24"
        "178.197.128.0/17" # Swisscom
        "31.165.62.80" # Fritzbox
        "195.176.96.0/19" # ETHZ
      ];
      zones = [
        {
          name = domain;
          master = true;
          file = builtins.toFile domain ''
            $TTL 1d
            $ORIGIN ${domain}.

            @ IN SOA ns3.${domain}. hostmaster.${domain}. (
              2
              3H
              15
              1w
              3h
            )

            ${domain}. IN NS ns3.${domain}.
            ${domain}. IN NS ns4.${domain}.

            ns3 IN A ${ip}
            ns4 IN A ${ip}

            @ IN A ${ip}
            @ IN AAAA ${ip6}
            ${concatMapStringsSep "\n" (sub:
              "${sub} IN CNAME ${domain}."
            ) subdomains}
          '';
        }
      ];
    };
  };
}
