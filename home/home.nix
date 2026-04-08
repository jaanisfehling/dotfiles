{
  config,
  pkgs,
  ...
}: let
  neovimTools = with pkgs; [
    # Core CLI helpers commonly used by Neovim plugins
    ripgrep
    fd
    tree-sitter

    # Lua
    lua-language-server
    stylua

    # Nix
    nixd
    alejandra

    # Shell
    bash-language-server
    shellcheck
    shfmt

    # Python
    pyright
    ruff
    black

    # JS / TS / Web
    typescript-language-server
    prettierd
    vscode-langservers-extracted
    yaml-language-server
    taplo
    marksman

    # Rust
    rust-analyzer
    rustfmt
    clippy

    # C / C++
    clang-tools
    cmake-language-server
    vscode-extensions.vadimcn.vscode-lldb

    # Haskell
    haskell-language-server
    fourmolu
    hlint
  ];

  devToolchains = with pkgs; [
    # General build/debug
    git
    gcc
    gdb
    cmake
    ninja
    pkg-config
    bear

    # Rust
    cargo
    rustc

    # Haskell
    ghc
    cabal-install
    stack
    ghcid
  ];
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jaanis";
  home.homeDirectory = "/home/jaanis";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs;
    [
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

      gnumake
      gcc
      ripgrep
      unzip
      xclip
      lldb
      lazygit
      nerd-fonts.jetbrains-mono
      discord
      tmux
    ]
    ++ devToolchains ++ neovimTools;

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

    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/home/jaanis/dotfiles/config/nvim";

    ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "/home/jaanis/dotfiles/config/tmux.conf";
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
  #  /etc/profiles/per-user/jaanis/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Jaanis Fehling";
        email = "jaanisfehling@gmail.com";
      };
      init.defaultBranch = "master";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    # Nice to have for plugin/provider compatibility
    withNodeJs = true;
    withPython3 = true;

    # Ensures LSPs/formatters are visible even when Neovim is launched from a GUI
    extraPackages = neovimTools;
  };

  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Nord";
      font-size = 11;
      cursor-style = "block";
      shell-integration-features = "no-cursor";
      window-padding-balance = true;
      window-padding-x = 0;
      window-padding-y = 0;
    };
  };
}
