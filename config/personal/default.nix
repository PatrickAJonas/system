{

  imports = [
    ./keys.nix
    ./znc.nix
    ./wlan.nix
  ];

  # Needed for Swisscom router web interface
  networking.extraHosts = ''
    192.168.1.1 swisscom.mobile
  '';

  mine.dns.dkimKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDqEBkfzMeMpXcHmMnasi5sE98SGIphwuWMHFmtXAtqGKsr8gjOQ5rZLTRhqOZR2CZc6xY2iCBtQ6nxFOHfJ/UW5tNanvi2nuo4jhrq9+ZNupdsKwxDpBNm7W9HVO2a0FP6dGa9bme0Zc4wqf9Socialr02YuZqRKwU3kBQtfRg4wIDAQAB";

  mine.dns.allowedNetworks = [
    "127.0.0.0/24"
    "178.197.128.0/17" # Swisscom
    "31.165.62.80" # Fritzbox
    "31.165.0.0/16" # Sunrise
    "195.176.96.0/19" # ETHZ
  ];

  mine.dns.ipnsHash = "QmcF3xqxFZxDLBJ5fNmr8vZ5p83SoS5zuavYMhizh2L1dp";

  mine.openvpn.server.subnet = "10.149.76.0";

  mine.xUserConfig = {
    services.redshift = {
      latitude = "47.4";
      longitude = "9.2";
    };
  };

}
