{ config, pkgs, ... }:

{
  imports = [
	  ./wlogout.nix
	  ./swaylock.nix
	  ./swayidle.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "rajesh";
  home.homeDirectory = "/home/rajesh";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    # Wordlist for vim dictionary-completion, symlinked below
    pkgs.miscfiles
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    ".local/share/dict/words".source = "${pkgs.miscfiles}/share/web2";

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/rajesh/etc/profile.d/hm-session-vars.sh
  #

  gtk.enable = true;
  qt.enable = true; 
  qt.platformTheme.name = "gtk3";

  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      package = pkgs.catppuccin-gtk.override {
        variant = "mocha";
        accents = [ "blue" ];
      };
      name = "catppuccin-mocha-blue-standard";
    };

    # catppuccin-gtk's gtk4 CSS breaks current libadwaita; let libadwaita style itself
    gtk4.theme = null;

    # libadwaita ignores prefer-dark-theme and only honours dconf color-scheme
    colorScheme = "dark";
    # colorScheme also emits this for gtk4, which makes libadwaita warn
    gtk4.extraConfig.gtk-application-prefer-dark-theme = false;
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };


  services.udiskie.enable = true;

  # zathura-cb claims inode/directory in its .desktop MimeType list, which can
  # win as the fallback default when nothing else claims it explicitly.
  home.activation.fixDirectoryMimeDefault = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${pkgs.xdg-utils}/bin/xdg-mime default org.gnome.Nautilus.desktop inode/directory
  '';


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
