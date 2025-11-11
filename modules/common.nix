{ config, lib, pkgs, ... }:

{
  # Common packages for all systems
  environment.systemPackages = with pkgs; [
    git
    vim-full
    htop
    curl
    wget
  ];

  # Environment
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  # Common settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Allow unfree packages (like vscode, etc)
  nixpkgs.config.allowUnfree = true;
}
