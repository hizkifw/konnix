{ config, lib, pkgs, ... }: {
  options.konnix.development = {
    enable = lib.mkEnableOption "development tools";

    docker = {
      enable = lib.mkEnableOption "docker" // { default = true; };
      username = lib.mkOption {
        type = lib.types.str;
        description = "Username to add to the docker group";
      };
    };

    rust.enable = lib.mkEnableOption "rust" // { default = true; };
    dotnet.enable = lib.mkEnableOption "dotnet" // { default = true; };

    tmux.enable = lib.mkEnableOption "tmux" // { default = true; };
  };

  config = lib.mkIf config.konnix.development.enable (lib.mkMerge [
    # Base dev tools
    {
      environment.systemPackages = with pkgs; [
      ];

      programs.git = {
        enable = true;
        lfs.enable = true;
        config = {
          init.defaultBranch = "main";
        };
      };

      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
      };
    }

    # docker
    (lib.mkIf config.konnix.development.docker.enable {
      virtualisation.docker.enable = true;
      users.users.${config.konnix.development.docker.username}.extraGroups = [ "docker" ];
    })

    # rust
    (lib.mkIf config.konnix.development.rust.enable {
      environment.systemPackages = with pkgs; [ rustc cargo rust-analyzer ];
    })

    # dotnet
    (lib.mkIf config.konnix.development.dotnet.enable {
      environment.systemPackages = with pkgs; [
        (
          with dotnetCorePackages;
          combinePackages [
            sdk_8_0
            sdk_9_0
            sdk_10_0
            aspnetcore_8_0
            aspnetcore_9_0
            aspnetcore_10_0
          ]
        )
      ];
    })

    # tmux
    (lib.mkIf config.konnix.development.tmux.enable {
      programs.tmux = {
        enable = true;
        keyMode = "vi";
        historyLimit = 10000;
        clock24 = true;
        terminal = "xterm-256color";
        extraConfig = ''
          # display
          set -g status-bg black
          set -g status-fg white

          # window splits
          bind e split-window -v
          bind v split-window -h

          # pane navigation
          bind Enter select-pane -t :.+
          bind -n C-h select-pane -L  # move left
          bind -n C-j select-pane -D  # move down
          bind -n C-k select-pane -U  # move up
          bind -n C-l select-pane -R  # move right

          # pane resizing
          bind -r H resize-pane -L 2
          bind -r J resize-pane -D 2
          bind -r K resize-pane -U 2
          bind -r L resize-pane -R 2

          # window navigation
          unbind n
          unbind p
          bind t new-window
          bind k previous-window # select previous window
          bind j next-window     # select next window
          bind h swap-window -t -1\; select-window -t -1 # reorder window left
          bind l swap-window -t +1\; select-window -t +1 # reorder window right
        '';
      };
    })
  ]);
}
