{ config, lib, pkgs, ... }:

{
  # WSL-specific settings
  wsl = {
    enable = true;
    defaultUser = "kitsune";

    # Mount Windows drives
    wslConf.automount.root = "/mnt";
  };

  # Hostname for this machine
  networking.hostName = "wsl-nixos";

  # User configuration
  users.users.kitsune = {  # Match defaultUser above
    isNormalUser = true;
    home = "/home/kitsune";
    extraGroups = [ "wheel" ];  # Enable sudo
    shell = pkgs.zsh;  # or pkgs.bash
  };

  # Module configuration
  konnix.development = {
    enable = true;
    docker.enable = false;
    docker.username = "kitsune";
  };

  # Packages specific to this WSL instance
  # environment.systemPackages = with pkgs; [
  #   vim
  # ];

  # This should match your first install version
  system.stateVersion = "25.05";
} 
