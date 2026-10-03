# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
   
  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;

  boot.loader.grub2-theme = {
    enable = true;
    theme = "stylish";
    footer = true;
  };

  fileSystems."/mnt/shared" = {
    device = "UUID=5CFAC2391FBCD763"; # /dev/nvme1n1p3
    fsType = "ntfs3";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "umask=0022"
      "windows_names"
      "nofail"
      "x-systemd.device-timeout=5s"
    ];
  };

  networking.hostName = "tiamat"; # Define your hostname.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

   # services.displayManager.sddm.enable = true;
   # services.displayManager.sddm.wayland.enable = true;
   # services.displayManager.sddm.theme = "breeze";
   # services.displayManager.sddm.package = pkgs.kdePackages.sddm;

  # Configure keymap in X11
  # services.xserver.xkb = {
  #   layout = "us";
  #   variant = "";
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.usbmuxd.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.pam.services.swaylock = {};
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.tailscale.enable = true;

  boot.kernelParams = [
    "usbcore.old_scheme_first=1"
    "usbcore.initial_descriptor_timeout=5"
  ];

  services.udev = {
    # NOTE: Xremap requires the following:
    # https://github.com/xremap/xremap?tab=readme-ov-file#running-xremap-without-sudo
    extraRules = ''
      KERNEL=="uinput", GROUP="input", TAG+="uaccess"
    '';
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rajesh = {
    isNormalUser = true;
    description = "Rajesh Sharma";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox
      fastfetch
      kitty
      tree
      nautilus
      fzf
      fishPlugins.fzf-fish
      atuin
      bat
      fd
      ripgrep
      dust
      gh
      jq
      pandoc
      tig
      ydiff
      eza
      zoxide
      delta
      difftastic
      lazygit
      yazi
      tealdeer
      sd
      hexyl
      tokei
      glow
      neovim
      gcc
      tree-sitter
      universal-ctags
      go
      gopls
      lua-language-server
      clang-tools
      solargraph
      rustup
      stylua
      rust-analyzer
      btop
      _1password-gui
      _1password-cli
      sqlite
      # logseq
      xwayland-satellite
      foot
      ghostty
      emacs
      libimobiledevice
      gvfs
      ifuse
      gthumb
      geeqie
      asciidoctor
      steam-run
      nmap
      nfs-utils
      chromium
      discord
      # freecad
      digikam
      icloudpd
    ];
  };


  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  fonts.packages = with pkgs; [
        iosevka
        nerd-fonts.iosevka
        maple-mono.NF
        (pkgs.callPackage ../../packages/space-grotesk.nix { })
  ];

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  users.users.rajesh.shell = pkgs.fish;

  programs.niri.enable = true;

  services.displayManager.regreet = {
    enable = true;
    theme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    settings = {
      GTK.application_prefer_dark_theme = true;
    };
  };


  fileSystems."/mnt/nas/photos" = {
    device = "192.168.50.190:/mnt/Nas_Storage/Photos";
    fsType = "nfs";
    options = [
      "nfsvers=4.2"
      "_netdev"
      "nofail"
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
    ];
  };

  services.greetd = {
      enable = true;
      restart = true;
      settings.default_session = {
        command = "${lib.getExe pkgs.cage} -s -- ${lib.getExe config.services.displayManager.regreet.package}";
      };
    };


  nixpkgs.overlays = [ inputs.claude-code.overlays.default ];
# environment.systemPackages = [ pkgs.claude-code ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim-full
    kitty
    git
    ruby
    python3
    fish
    waybar
    tmux
    wl-clipboard
    cliphist
    hyprpicker
    pavucontrol
    fuzzel
    swaynotificationcenter
    libnotify
    swaybg
    claude-code
    codex
    visidata
    duckdb
    vlc
    imv
    inkscape
    zathura
    grim
    slurp
    satty
    gsimplecal
    libqalculate
    qalculate-gtk
  ];

  systemd.services.greetd.environment = {
    GTK_THEME = "Adwaita:dark";
  };


  virtualisation.docker.enable = true;

  programs.fish.enable = true;

  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;

  services.udisks2.enable = true;

  services.flatpak.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
