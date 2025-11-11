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
  };

  config = lib.mkIf config.konnix.development.enable (lib.mkMerge [
    # Base dev tools
    {
      environment.systemPackages = with pkgs; [
        git
      ];
    }

    # Docker
    (lib.mkIf config.konnix.development.docker.enable {
      virtualisation.docker.enable = true;
      users.users.${config.konnix.development.docker.username}.extraGroups = [ "docker" ];
    })

    # Rust
    (lib.mkIf config.konnix.development.rust.enable {
      environment.systemPackages = with pkgs; [ rustc cargo rust-analyzer ];
    })
  ]);
}
