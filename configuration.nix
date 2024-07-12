# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  #Experimental Options#
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
  networking.hostName = "the-abyss"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Hardware
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.xpadneo.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };  

  # Set your time zone.
  time.timeZone = "America/Detroit";

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
  # You can disable this if you're only using the Wayland session.
  services.xserver = {
    enable = true;
    videoDrivers = ["amdgpu"];
  };

  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
    };

  # Enable lightdm with the slick greeter
  services.xserver.displayManager.lightdm.greeters.slick = {
    enable = true;
    extraConfig = "background=/etc/nixos/lightdm-wallpapers/darksnow.jpg";
    };

#Garbage collector
nix.gc.automatic = true;

#Systemd options
systemd.services.lactd = {
    description = "AMDGPU Control Daemon";
    enable = true;  
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    wantedBy = ["multi-user.target"];
  };
  
  # Configure keymap in X11
  services.xserver.xkb = {
   layout = "us";
   variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dusk = {
    isNormalUser = true;
    description = "Kris";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
    kdePackages.kate
      
    ];
  };

  # Enable software.
 # programs.firefox.enable = true;
  programs.fish.enable = true;
  programs.zsh.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; #Opens fw ports for Steam Remote Play
    dedicatedServer.openFirewall = true; #Opens fw ports for dedicated servers
    gamescopeSession.enable = true; #Enables gamescope
  };
  programs.gamemode.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  pkgs.floorp
  pkgs.librewolf
  pkgs.r2modman
  pkgs.prismlauncher
  pkgs.krita
  pkgs.vlc
  pkgs.heroic
  pkgs.kitty
  pkgs.goverlay
  pkgs.protonup-qt
  pkgs.themechanger
  pkgs.kdePackages.qtstyleplugin-kvantum
  pkgs.armcord
  pkgs.ryujinx
  pkgs.rpcs3
  pkgs.home-manager
  pkgs.nix-prefetch-git
  pkgs.firefox
  pkgs.lact
  pkgs.fastfetch
  pkgs.mesa
  pkgs.vulkan-tools
  pkgs.vulkan-loader
  pkgs.radeontop
  pkgs.radeontools
  pkgs.radeon-profile
  pkgs.gamescope
  pkgs.kitty-img
  pkgs.lightly-qt
  pkgs.fish
  pkgs.zsh
  pkgs.starship
  pkgs.jdk17
  pkgs.jdk8
  pkgs.git
  pkgs.libsForQt5.lightly
  pkgs.kdePackages.partitionmanager
  
  ];

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
  # Currently configured for minecraft, configure as needed.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 25569 ];
    allowedUDPPorts = [ 25569 ];
  };    

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
