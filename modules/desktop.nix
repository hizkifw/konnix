{ config, lib, pkgs, ... }: {
  options.konnix.desktop = {
    enable = lib.mkEnableOption "desktop environment";

    wm = lib.mkOption {
      type = lib.types.enum [ "hyprland" ];
      default = "hyprland";
      description = "window manager";
    };

    ime.enable = lib.mkEnableOption "IME" // { default = true; };

    bluetooth.enable = lib.mkEnableOption "Bluetooth" // { default = true; };
    networkmanager.enable = lib.mkEnableOption "NetworkManager" // { default = true; };

    communications.enable = lib.mkEnableOption "communications";
    multimedia.enable = lib.mkEnableOption "multimedia";
    gaming.enable = lib.mkEnableOption "gaming";
  };

  config = lib.mkIf config.konnix.desktop.enable (lib.mkMerge [
    {
      services.dbus.enable = true;

      # Audio
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      # Keyring
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.greetd.enableGnomeKeyring = true;

      # Browser
      programs.chromium.enable = true;

      # Fonts
      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji
        noto-fonts-extra

        source-sans-pro
        source-serif-pro

        nerd-fonts.fira-code
        inter
        dm-sans
      ];
    }

    # hyprland
    (lib.mkIf (config.konnix.desktop.wm == "hyprland") {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };

      # Screen sharing and capture
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
        config.common.default = "*";
      };

      # Packages
      environment.systemPackages = with pkgs; [
        libnotify mako # Notifications
        hyprpaper # Wallpaper
        waybar # Status bar
        rofi-wayland # Launcher
        kitty # Terminal
        wl-clip-persist # Clipboard
        ffmpegthumbnailer # Thumbnails
        pavucontrol # Audio control
      ];

      # File manager
      programs.thunar = {
        enable = true;
        plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
      };

      # Configuration for XFCE apps
      programs.xfconf.enable = true;

      # Mount, trash, and other functionalities
      services.gvfs.enable = true;

      # Thunar thumbnails
      services.tumbler.enable = true;
    })

    # IME
    (lib.mkIf config.konnix.desktop.ime.enable {
      i18n.inputMethod = {
        type = "fcitx5";
        fcitx5 = {
          waylandFrontend = true;
          addons = with pkgs; [
            fcitx5-mozc        # Japanese input
            fcitx5-gtk         # GTK integration
            fcitx5-configtool  # Config GUI
          ];
        };
      };

      environment.sessionVariables = {
        GTK_IM_MODULE = "fcitx";
        QT_IM_MODULE = "fcitx";
        XMODIFIERS = "@im=fcitx";
        GLFW_IM_MODULE = "ibus"; # for some apps like kitty
      };
    })

    # Bluetooth
    (lib.mkIf config.konnix.desktop.bluetooth.enable {
      services.blueman.enable = true;
    })

    # NetworkManager
    (lib.mkIf config.konnix.desktop.networkmanager.enable {
      networking.networkmanager.enable = true;
      programs.nm-applet.enable = true;
    })

    # Communications
    (lib.mkIf config.konnix.desktop.communications.enable {
      environment.systemPackages = with pkgs; [
        vesktop
        telegram-desktop
      ];
    })

    # Multimedia
    (lib.mkIf config.konnix.desktop.multimedia.enable {
      programs.obs-studio = {
        enable = true;
        enableVirtualCamera = true;
        plugins = with pkgs.obs-studio-plugins; [
          obs-pipewire-audio-capture
          obs-command-source
          obs-backgroundremoval
        ];
      };
    })

    # Gaming
    (lib.mkIf config.konnix.desktop.gaming.enable {
      programs = {
        steam.enable = true;
        steam.extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];

        alvr.enable = true;
      };
    })
  ]);
}
