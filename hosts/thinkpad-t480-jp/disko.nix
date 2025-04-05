{
    disko.devices = {
        disk = {
            main = {
                type = "disk";
                device = "/dev/nvme0n1";
                content = {
                    type = "gpt";
                    partitions = {
                        ESP = {
                            size = "512M";
                            type = "EF00";
                            content = {
                                type = "filesystem";
                                format = "vfat";
                                mountpoint = "/boot";
                                mountOptions = [ "umask=0077" ];
                            };
                        };
                        swap = {
                            size = "9G";  # Adjust as needed for your hibernation needs.
                            content = {
                                type = "luks";
                                name = "cryptswap";
                                settings = {
                                    allowDiscards = true;
                                    keyFile = "/key/secret.key";
                                    preOpenCommands = ''
                                        mkdir -m 0755 -p /key
                                        sleep 2 # To make sure the usb key has been loaded
                                        mount -n -t vfat -o ro /dev/disk/by-uuid/16C0-4C72 /key
                                        '';
                                };
                                content = {
                                    type = "swap";
                                    extraArgs = [ "-L" "swap-part" "-f" ];
                                };
                            };
                        };
                        luks = {
                            size = "100% - 9G";
                            content = {
                                type = "luks";
                                name = "crypted";
# disable settings.keyFile if you want to use interactive password entry
#passwordFile = "/tmp/secret.key"; # Interactive
                                settings = {
                                    allowDiscards = true;
                                    keyFile = "/key/secret.key";
                                };
# additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                                content = {
                                    type = "btrfs";
                                    extraArgs = [ "-L" "nixos" "-f" ];
                                    subvolumes = {
                                        "/root" = {
                                            mountpoint = "/";
                                            mountOptions = [
                                                "subvol=root"
                                                    "compress=zstd"
                                                    "noatime"
                                            ];
                                        };
                                        "/home" = {
                                            mountpoint = "/home";
                                            mountOptions = [
                                                "subvol=home"
                                                    "compress=zstd"
                                                    "noatime"
                                            ];
                                        };
                                        "/nix" = {
                                            mountpoint = "/nix";
                                            mountOptions = [
                                                "subvol=nix"
                                                    "compress=zstd"
                                                    "noatime"
                                            ];
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        };
    };
};
}
