{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "gkatai";
  home.homeDirectory = "/home/gkatai";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.ncdu
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
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/gkatai/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
    };
    initExtra = ''
      parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
      }
      export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\]\n$ "
    '';
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      zhuangtongfa.material-theme
      pkief.material-icon-theme
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      editorconfig.editorconfig
      donjayamanne.githistory
      jnoortheen.nix-ide
      file-icons.file-icons
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "jsdoc-generator";
        publisher = "crystal-spider";
        version = "2.0.2";
        sha256 = "sha256-q3emOThJ+YJN7j/WtSL0JCFTkVY9DYysUJ44XgN8rSU=";
      }
    ];
    keybindings = [
      {
        key = "ctrl+k s";
        command = "-workbench.action.files.saveWithoutFormatting";
      }
      {
        key = "ctrl+k s";
        command = "workbench.action.files.saveFiles";
      }
    ];
    userSettings = {
      window.zoomLevel = 2;
      window.menuBarVisibility = "toggle";
      extensions.autoCheckUpdates = false;
      git.autofetch = true;
      git.openRepositoryInParentFolders = "never";
      update.mode = "none";
      editor.formatOnSave = true;
      editor.defaultFormatter = "esbenp.prettier-vscode";
      workbench.colorTheme = "One Dark Pro Flat";
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
      };
      workbench.iconTheme = "material-icon-theme";
      emmet.showAbbreviationSuggestions = false;
      emmet.showExpandedAbbreviation = "never";
      jsdoc-generator.includeTime = false;
      jsdoc-generator.includeDate = false;
    };
    enableUpdateCheck = false;
    mutableExtensionsDir = false;
    enableExtensionUpdateCheck = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "Noto Sans Mono";
        };
      };
      window = {
        decorations = "none";
        padding = {
          x = 10;
          y = 10;
        };
        dynamic_padding = true;
      };
      key_bindings = [
        {
          key = "Minus";
          mods = "Control";
          action = "DecreaseFontSize";
        }
        {
          key = "Key3";
          mods = "Control";
          action = "IncreaseFontSize";
        }
      ];
    };
  };

  programs.mpv = {
    enable = true;
    config = {
      save-position-on-quit = true;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
