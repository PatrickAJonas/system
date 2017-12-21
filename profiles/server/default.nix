{ nodes, config, lib, pkgs, ... }:

{

  imports = [
    ./ssh.nix
    ../../modules/web.nix
    ../../modules/radicale.nix
    ../../modules/bind.nix
    ../../modules/console.nix
    ../../modules/beets.nix
    ../../modules/mpdServer.nix
    ../../modules/namecoin.nix
    ../../modules/youtube.nix
    ../../modules/info.nix
    ../../modules/git-host.nix
    ../../modules/ssh.nix
    ../../modules/ipfs.nix
    ../../modules/znc.nix
    ../../private/server.nix
    /home/infinisil/eth/DS/CardGame/Server/module.nix
  ];

  boot.loader.timeout = 60;

  # minimalization, taken from <nixpkgs/nixos/modules/profiles>
  sound.enable = false;
  boot.kernelParams = [ "panic=1" "boot.panic_on_fail" ];
  systemd.enableEmergencyMode = false;
  fonts.fontconfig.enable = false;
  programs.ssh.setXAuthLocation = false;
  security.pam.services.su.forwardXAuth = lib.mkForce false;
  #environment.noXlibs = true;
  i18n.supportedLocales = [ (config.i18n.defaultLocale + "/UTF-8") ];
  services.nixosManual.enable = false;
  programs.info.enable = false;

  environment.systemPackages = with pkgs; [
    youtube-dl
    iperf
  ];

  networking.firewall.allowedTCPPorts = [
    5001 # iperf
  ] ++ [ nodes.pc.config.localserver.sshport nodes.laptop.config.localserver.sshport ];

  networking.firewall.logRefusedConnections = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  services.ipfs.autostart = false;

  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    nixPath = [
      # Ruin the config so we don't accidentally run
      # nixos-rebuild switch on the host (thanks grahamc!)
      "nixos-config=${pkgs.writeText "throw-configuration.nix" ''
        throw "Hey dummy, you're on your server! Use NixOps!"
      ''}"
      "nixpkgs=/run/current-system/nixpkgs"
    ];
  };

  system.extraSystemBuilderCmds = ''
    ln -sv ${lib.cleanSource pkgs.path} $out/nixpkgs
  '';

  services.nginx = {
    virtualHosts."mac.${config.networking.domain}" = {
      forceSSL = true;
      enableACME = true;
      root = "/webroot/mac";
      locations."/".proxyPass = "http://localhost:${toString nodes.laptop.config.localserver.webserverport}";
    };
    virtualHosts."pc.${config.networking.domain}" = {
      forceSSL = true;
      enableACME = true;
      root = "/webroot/pc";
      locations."/".proxyPass = "http://localhost:${toString nodes.pc.config.localserver.webserverport}";
      basicAuth.infinisil = config.private.passwords."pc.infinisil.com";
    };
  };

  networking.subdomains = [ "test" "ipfs" ] ++ [ "mac" "pc" ];

  services.nginx.virtualHosts."test.${config.networking.domain}" = {
    forceSSL = true;
    enableACME = true;
    root = "/webroot/test";
    locations."/".extraConfig = "autoindex on;";
  };

  services.nginx.virtualHosts."ipfs.${config.networking.domain}" = {
    forceSSL = true;
    enableACME = true;
    root = "/webroot";
    locations."/".proxyPass = "http://localhost:8080";
  };

  home-manager.users.infinisil = {
    # https://github.com/keybase/keybase-issues/issues/1712#issuecomment-141226705
    home.sessionVariables.GPG_TTY = "$(tty)";

    programs.htop.meters = {
      left = [
        "Memory"
        "CPU"
        "Swap"
        { kind = "CPU"; mode = 3; }
      ];
      right = [
        { kind = "Clock"; mode = 4; }
        "Uptime"
        "Tasks"
        "LoadAverage"
      ];
    };

  };
}
