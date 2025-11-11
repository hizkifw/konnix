{ config, lib, pkgs, ... }:

{
  # Common packages for all systems
  environment.systemPackages = with pkgs; [
    git
    htop
    curl
    wget
  ];

  # Editor
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    configure.customRC = ''
      set shiftwidth=2
      set softtabstop=2
      set tabstop=2
      set expandtab
      set smarttab
    '';
  };

  # Environment
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
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
