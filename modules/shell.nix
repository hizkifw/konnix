{ config, lib, pkgs, ... }:

{
  environment.shells = with pkgs; [ zsh ];

  environment.shellAliases = {
    gpoh = "git push -u origin HEAD";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 10000;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
    };
    promptInit = "";
    interactiveShellInit = ''
      export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

      # Customize your oh-my-zsh options here
      ZSH_THEME="candy"
      plugins=(git)

      source $ZSH/oh-my-zsh.sh
    '';
  };
}
