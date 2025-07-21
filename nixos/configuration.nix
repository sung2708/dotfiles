{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname & Network
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Time zone & Locale
  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "vi_VN";
    LC_IDENTIFICATION = "vi_VN";
    LC_MEASUREMENT = "vi_VN";
    LC_MONETARY = "vi_VN";
    LC_NAME = "vi_VN";
    LC_NUMERIC = "vi_VN";
    LC_PAPER = "vi_VN";
    LC_TELEPHONE = "vi_VN";
    LC_TIME = "vi_VN";
  };

  # Enable X11
  services.xserver.enable = true;

  # Display Manager: LightDM
  services.xserver.displayManager.lightdm.enable = true;

  # Window Manager: i3
  services.xserver.windowManager.i3.enable = true;

  # Keyboard layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Printing
  services.printing.enable = true;

  # Sound: PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User
  users.users.sungp = {
    isNormalUser = true;
    description = "Phan Duc Sung";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  # Shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Unfree packages
  nixpkgs.config.allowUnfree = true;

  # Programs
  programs.firefox.enable = true;

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "JetBrainsMono NF" ];
        sansSerif = [ "JetBrainsMono NF" ];
        monospace = [ "JetBrainsMono NFP" ];
      };
    };
  };

  # Packages
  environment.systemPackages = with pkgs; [
    psmisc
    neovim
    wget
    curl
    zsh
    git
    gitflow
    fzf
    thefuck
    eza
    python314
    ripgrep
    fd
    bat
    tmux
    fastfetch
    i3
    i3status
    pulseaudio
    light
    dmenu
    xterm
    feh
    networkmanagerapplet
    lxappearance
    pavucontrol
    polybar
    wezterm
    ghostty
    stow
    clang-tools
    gcc
    xclip
    wl-clipboard
    gnumake
    go
    yarn
    nodejs_24
    unzip
    spotify
    tldr
    bash
    bc
    coreutils
    gawk
    jq
    playerctl
    nerd-fonts.jetbrains-mono
    rofi
    youtube-music
    lua-language-server
    luajitPackages.luarocks-nix
    stylua
    cpplint
    djlint
    eslint_d
    golangci-lint
    gopls
    isort
    gopls
    pyright
    stylua
    typescript-language-server
    black
    obs-studio
    flameshot
    mongodb-compass
    postman
  ];

  # System version
  system.stateVersion = "25.05";
}


