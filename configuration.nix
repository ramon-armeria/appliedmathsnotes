{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

   nixpkgs.config.allowUnfree = true;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.enableRedistributableFirmware = true;

  #Network
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  services.openvpn.servers.nordvpn = {
    config = "config /etc/nordvpn/se627.nordvpn.com.tcp.ovpn";
    autoStart = false;
  };

  # Set your time zone.
   time.timeZone = "Europe/London";

  # Select internationalisation properties.
    i18n.defaultLocale = "en_GB.UTF-8";
    console = {
      packages = [ pkgs.terminus_font ];
      font = "ter-v16n";
      keyMap = "uk";
    };

  # Enable the X11 windowing system.
   services.xserver = {
     enable = true;
     displayManager.sddm.enable = true;
     desktopManager.plasma6.enable = true;
     xkb.layout = "gb";
  };

  # Enable sound.
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
   };

# Enable CUPS printing
     services.printing.enable = true;

   # Use HPLIP with the plugin for HP support (e.g., scanning or proprietary features)
     services.printing.drivers = [ pkgs.hplipWithPlugin ];
     services.printing.browsing = true;
     services.printing.defaultShared = true;
     # Optional but recommended
     hardware.printers.ensurePrinters = [];
   # Enable scanner support
     hardware.sane.enable = true;

   # Allow network printer discovery via mDNS/Avahi
     services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
     };

   # Allow the CUPS web interface through the firewall
     networking.firewall.allowedTCPPorts = [ 631 ];


  #Users
    users.users.nixos_u0 = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networknanger" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
    ];
   };

  #Environmental Packages
    environment.systemPackages = with pkgs; [
     git
     openssh
     wget
     curl
     micro
     firefox
     julia
     tor-browser
     openvpn
     catppuccin-sddm
     texstudio
     (texlive.combine {
      inherit (texlive)
        # Base + LaTeX
        scheme-medium
        collection-latexrecommended
        collection-latexextra

        # Maths + science
        collection-mathscience     # amsmath, mathtools, amsthm, siu>
        collection-bibtexextra     # biblatex/biber styles, etc.
        collection-fontsrecommended

        # Tools I actually want available:
        latexmk
        pgfplots
        tikz-cd
        standalone
        xcolor
        etoolbox
        cleveref
        csquotes
        l3packages;  # LaTeX3 core (many packages depend on>
    })
     libreoffice
     maxima
     wxmaxima
    ];

  #Packages & characteristics

  #Tmux
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g set-clipboard on
    '';
    };
 fonts.packages = with pkgs; [
   jetbrains-mono
   dejavu_fonts
   ibm-plex
];

system.stateVersion = "25.11"; # Did you read the comment?

}

