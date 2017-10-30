{ config, lib, pkgs, ...}:

let

  cfg = config.mpd;

in

with lib;

{
  imports = [
    ./mpd.nix
    ./mpdClient.nix
  ];

  services.mpd = {
    enable = true;
    user = "infinisil";
    group = "users";
    musicDirectory = "${cfg.musicDir}/data";
    readonlyPlaylists = true;
    playlistDirectory = "${cfg.musicDir}/playlists";
    network.port = cfg.port;
    network.listenAddress = "0.0.0.0";
    extraConfig = ''
      replaygain "track"
      audio_output {
        type            "httpd"
        name            "My HTTP Stream"
        encoder         "lame"
        port            "${toString config.mpd.httpPort}"
        bitrate         "${toString config.mpd.bitRate}"
        format          "44100:16:2"
        max_clients     "0"
        always_on "yes"
      }
      password "${config.passwords.mpd}@read,add,control"
    '';
  };

  networking.firewall.allowedTCPPorts = [ config.mpd.port ];

  services.nginx.virtualHosts."tune.${config.networking.domain}" = {
    root = "/webroot";
    locations."/".proxyPass = "http://localhost:${toString config.mpd.httpPort}";
  };

  # Needs to be mounted before mpd is started and unmounted after mpd stops
  systemd.services.mpd.after = [ "home-infinisil-Music.mount" ];

}
