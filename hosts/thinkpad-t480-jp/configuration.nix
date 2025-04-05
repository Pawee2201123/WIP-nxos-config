# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs ,... }:

{
    imports =
        [ # Include the results of the hardware scan.
            ./hardware-configuration.nix
            inputs.xremap-flake.nixosModules.default
            #inputs.disko.nixosModules.default
            ./disko.nix
        ];

# Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.initrd.luks.devices."luks-1264de94-e840-4988-8cee-66d4ceefbb2d".device = "/dev/disk/by-uuid/1264de94-e840-4988-8cee-66d4ceefbb2d";
    networking.hostName = "nixos"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

        nix.settings.experimental-features = ["nix-command" "flakes"];


# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
    networking.networkmanager.enable = true;

# Set your time zone.
    #time.timeZone = "Asia/Tokyo";
    time.timeZone = "Asia/Bangkok";

# Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "ja_JP.UTF-8";
        LC_IDENTIFICATION = "ja_JP.UTF-8";
        LC_MEASUREMENT = "ja_JP.UTF-8";
        LC_MONETARY = "ja_JP.UTF-8";
        LC_NAME = "ja_JP.UTF-8";
        LC_NUMERIC = "ja_JP.UTF-8";
        LC_PAPER = "ja_JP.UTF-8";
        LC_TELEPHONE = "ja_JP.UTF-8";
        LC_TIME = "ja_JP.UTF-8";
    };

    console={
        keyMap = "jp106";
    };
    services.gnome.gnome-keyring.enable = true;

    programs.sway ={
        enable = true;
        wrapperFeatures.gtk = true;
    };
#setup fcitx5
    i18n.inputMethod = {
        type = "fcitx5";
        enable = true;
        fcitx5.waylandFrontend = true;
        fcitx5.addons = with pkgs; [
            fcitx5-mozc
            fcitx5-gtk
        ];
    };


    users.defaultUserShell = pkgs.zsh;
    programs.zsh.enable = true;



# Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.sisyphus = {
        isNormalUser = true;
        description = "sisyphus";
        extraGroups = [ "networkmanager" "wheel" "input"];
        packages = with pkgs; [];
    };
    security.sudo.wheelNeedsPassword = false;
# Allow unfree packages
    nixpkgs.config.allowUnfree = true;

# List packages installed in system profile. To search, run:
# $ nix search wget
    environment.systemPackages = with pkgs; [
        neovim 
            home-manager
            wget
            git

    ];

#fonts
    fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
            noto-fonts
            sarabun-font
    ];
# for xremap
    services.xremap = {
        config = {
            modmap = [
            {
                name = "main remaps";
                remap = {
                    CapsLock = {
                        held = "leftctrl";
                        alone = "esc";
                    };
                    Ctrl_L = "CapsLock";
                    Muhenkan = "backspace";
                };
            }
            ];
        };
    };
    hardware.uinput.enable = true;
    users.groups.uinput.members = ["sisyphus"];
    users.groups.input.members = ["sisyphus"];
# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# List services that you want to enable:

# Enable the OpenSSH daemon.
    services.openssh.enable = true;

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
    system.stateVersion = "24.11"; # Did you read the comment?

#For thinkpad
        services.tlp.enable = true;
# Battery power management
    services.upower.enable = true;
}

