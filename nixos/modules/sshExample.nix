# nixos/modules/ssh.nix
{ config, pkgs, lib, ... }:

with lib;
{
  options.services.sshExample = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable the SSH server.";
    };

    secure = mkOption {
      default = false;
      type = types.bool;
      description = "Enable stricter security settings for SSH.";
    };
  };

  config = mkIf config.services.sshExample.enable {
    services.openssh.enable = true;

    services.openssh.settings = mkIf config.services.sshExample.secure {
      PermitRootLogin = "no";
      PasswordAuthentication = "no";
      # Add other security hardening options here as needed
    };
  };
}
